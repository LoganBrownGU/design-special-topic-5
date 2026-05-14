use std::{error::Error, thread};
use liveplot::{LivePlotConfig, PlotPoint, PlotSink, Trace, channel_plot, run_liveplot};

use crate::pico::{Pico, PicoFrequency, PicoSample, PicoTime, PicoTimebase};

mod signal_processing;
mod pico;

fn do_frame(pico: &Pico, timebase: PicoTimebase, sink: &PlotSink, fs: PicoFrequency, signal_trace: &Trace, fft_trace: &Trace) -> Result<(), Box<dyn Error>> {
    let mut tbuf = vec![0 as PicoTime;   fs as usize];
    let mut sbuf = vec![0 as PicoSample; fs as usize];
    pico.gather_samples(timebase, &mut tbuf, &mut sbuf)?;
    
    sink.clear_data(signal_trace)?;
    sink.clear_data(fft_trace)?;
    for p in tbuf.iter().zip(&sbuf).map(|(a, b)| PlotPoint { x: *a as f64 / 1e9, y: (*b as f64) / (PicoSample::MAX as f64) } ) {
        sink.send_point(signal_trace, p)?;
    }

    let fft = signal_processing::fft(&sbuf);
    let fft = fft[0..fft.len()/2].to_vec();
    let (fundamental, max) = fft.iter().enumerate().fold((0, f64::MIN), |p0, p1| if p0.1 > *p1.1 { p0 } else { (p1.0, *p1.1) });
    for p in tbuf.iter().zip(&fft).map(|(a, b)| PlotPoint { x: *a as f64 / 1e9, y: *b / max } ) {
        sink.send_point(fft_trace, p)?;
    }

    eprint!("fundamental: {fundamental}Hz     \r");
    pico.generate_wave(fundamental as PicoFrequency, 0.1)?;

    Ok(())
}

fn main() {

    let (sink, rx) = channel_plot();
    let signal_trace = sink.create_trace("signal", Some("something idek"));
    let fft_trace = sink.create_trace("FFT", Some("something idek"));

    let t = thread::spawn(move || {
        let pico = Pico::new().unwrap();
        let (fs, timebase) = pico.get_fs_and_timebase(3000, 500).expect("Unable to select a timebase.");

        eprintln!("Gathering samples at {fs}Hz. Timebase = {timebase}.");
        while let Ok(_) = do_frame(&pico, timebase, &sink, fs, &signal_trace, &fft_trace) {}
    });

    let config = LivePlotConfig {
        time_window_secs: 1.0,
        auto_fit: liveplot::AutoFitConfig { auto_fit_to_view: true, keep_max_fit: true },
        max_points: 1e6 as usize,
        y_unit: Some("V".to_string()),
       ..Default::default() 
    };
    run_liveplot(rx, config).expect("Unable to start plot.");

    t.join().unwrap();
}
