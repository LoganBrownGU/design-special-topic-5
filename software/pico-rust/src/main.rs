use std::{error::Error, sync::mpsc::{SendError, channel}, thread};
use liveplot::{LivePlotConfig, PlotCommand, PlotPoint, PlotSink, Trace, channel_plot, run_liveplot};

use crate::pico::{Pico, PicoError, PicoFrequency, PicoSample, PicoTime, PicoTimebase};

mod signal_processing;
mod pico;

fn do_frame(
    pico: &Pico, 
    timebase: PicoTimebase, 
    sink: &PlotSink, 
    fs: PicoFrequency, 
    fft_trace: &Trace, 
    last_fundamental: PicoFrequency) 
-> Result<PicoFrequency, Box<dyn Error>> {
    let mut tbuf = vec![0 as PicoTime;   fs as usize];
    let mut sbuf = vec![0 as PicoSample; fs as usize];
    pico.gather_samples(timebase, &mut tbuf, &mut sbuf)?;
    
    sink.clear_data(fft_trace)?;

    let fft = signal_processing::fft(&sbuf);
    let f_min: PicoFrequency = 20;
    let fft = fft[(f_min as usize)..fft.len()/2].to_vec();
    let (fundamental, max) = fft.iter().enumerate().fold((0, f64::MIN), |p0, p1| if p0.1 > *p1.1 { p0 } else { (p1.0, *p1.1) });
    let fundamental = fundamental as PicoFrequency + f_min;
    for p in fft.iter().enumerate().map(|(a, b)| PlotPoint { x: (a + f_min as usize) as f64, y: *b / max } ) {
        sink.send_point(fft_trace, p)?;
    }

    eprint!("fundamental: {fundamental}Hz     \r");
    if fundamental != last_fundamental {
        pico.generate_wave(fundamental, 0.5)?;
    }

    Ok(fundamental)
}

fn main() {
    let target_fs = 3000;
    
    let (sink, rx) = channel_plot();
    let fft_trace = sink.create_trace("FFT", Some("something idek"));
    let (ready_tx, ready_rx) = channel::<()>();
    
    let t = thread::spawn(move || {
        let pico = Pico::new().expect("Failed to open PicoScope. Is it connected?");
        let (fs, timebase) = pico.get_fs_and_timebase(target_fs, 500).expect("Unable to select a timebase.");

        eprintln!("Gathering samples at {fs}Hz. Timebase = {timebase}.");
        ready_tx.send(()).unwrap();
        let mut last_fundamental = 0; let mut consecutive_errs = 0;
        while consecutive_errs < 5 {
            match do_frame(&pico, timebase, &sink, fs, &fft_trace, last_fundamental) {
                Err(e) if e.is::<SendError<PlotCommand>>() => { break; }
                Err(e) if e.is::<PicoError>()              => { eprintln!("PicoScope error occurred: {e}"); consecutive_errs += 1; continue; }
                Err(e)                                     => { eprintln!("Error occurred: {e}");           consecutive_errs += 1; continue; }
                Ok(new_fundamental)                        => { last_fundamental = new_fundamental; }
            }
            consecutive_errs = 0;
        }

        if consecutive_errs == 5 { eprintln!("Too many consecutive errors. Exiting."); drop(sink); }
    });

    if ready_rx.recv().is_err() { eprintln!("Failed to start reading from PicoScope."); return; }
    
    let config = LivePlotConfig {
        time_window_secs: target_fs as f64,
        auto_fit: liveplot::AutoFitConfig { auto_fit_to_view: true, keep_max_fit: true },
        max_points: 1e6 as usize,
        y_unit: Some("V".to_string()),
       ..Default::default() 
    };
    
    run_liveplot(rx, config).expect("Unable to start plot.");

    t.join().unwrap();
}
