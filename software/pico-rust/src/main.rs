use std::{error::Error, io::stdin, sync::mpsc::{SendError, Sender, channel}, thread, time::{Duration, Instant, SystemTime}};
use liveplot::{LivePlotConfig, PlotCommand, PlotPoint, PlotSink, Trace, channel_plot, run_liveplot};

use crate::{data_logger::{DataLogger, DataPoint}, pico::{Pico, PicoError, PicoFrequency, PicoSample, PicoTime, PicoTimebase}};

mod signal_processing;
mod pico;
mod data_logger;

const DEFAULT_F: PicoFrequency = 1000;
const DUTY_CYCLE: f64 = 0.5;

fn do_frame(
    pico: &Pico, 
    timebase: PicoTimebase, 
    sink: &PlotSink, 
    fs: PicoFrequency, 
    fft_trace: &Trace, 
    data_tx: &Sender<DataPoint>,
    last_fundamental: PicoFrequency,
    do_dynamic_frequency: bool,
) -> Result<PicoFrequency, Box<dyn Error>> {
    let mut tbuf = vec![0 as PicoTime;   fs as usize];
    let mut sbuf = vec![0 as PicoSample; fs as usize];

    let timestamp = SystemTime::now().duration_since(SystemTime::UNIX_EPOCH).unwrap().as_secs_f64();
    pico.gather_samples(timebase, &mut tbuf, &mut sbuf)?;

    tbuf.iter().zip(&sbuf).for_each(|(t, s)| {
        let t_f = *t as f64 * 1e9 + timestamp;
        data_tx.send(DataPoint(t_f, *s)).expect("Unable to send data point to plotter");
    });
    
    sink.clear_data(fft_trace)?;

    let fft = signal_processing::fft(&sbuf);
    let f_min: PicoFrequency = 20;
    let fft = fft[(f_min as usize)..fft.len()/2].to_vec();
    let (fundamental, max) = fft.iter().enumerate().fold((0, f64::MIN), |p0, p1| if p0.1 > *p1.1 { p0 } else { (p1.0, *p1.1) });
    let fundamental = fundamental as PicoFrequency + f_min;
    for p in fft.iter().enumerate().map(|(a, b)| PlotPoint { x: (a + f_min as usize) as f64, y: *b / max } ) {
        sink.send_point(fft_trace, p)?;
    }
   
    if fundamental != last_fundamental && do_dynamic_frequency {
        eprint!("fundamental: {fundamental}Hz     \r");
        pico.generate_wave(fundamental, DUTY_CYCLE)?;
    } else if !do_dynamic_frequency {
        pico.generate_wave(DEFAULT_F, DUTY_CYCLE)?;
        eprint!("static f:    {DEFAULT_F}Hz     \r");
    }

    Ok(fundamental)
}

fn main() {
    let mut logger_path = "./sound.dat".to_string();
    let args = std::env::args().collect::<Vec<String>>();
    if args.len() == 2 {
        logger_path = args[1].clone();
    }
    
    let target_fs = 3000;
    
    let (sink, rx) = channel_plot();
    let fft_trace = sink.create_trace("FFT", Some("something idek"));
    let (ready_tx, ready_rx) = channel::<()>();
    let (toggle_tx, toggle_rx) = channel::<()>();
    let (data_tx, data_rx) = channel();
    let logger = DataLogger::new(data_rx, logger_path, 1e5 as usize).expect("Failed to start logger.");
    
    let data_gathering = thread::spawn(move || {
        let pico = Pico::new().expect("Failed to open PicoScope. Is it connected?");
        let (fs, timebase) = pico.get_fs_and_timebase(target_fs, 500).expect("Unable to select a timebase.");

        eprintln!("Gathering samples at {fs}Hz. Timebase = {timebase}.");
        ready_tx.send(()).unwrap();
        let mut last_fundamental = 0; let mut consecutive_errs = 0;
        let mut do_dynamic_frequency = false; 
        while consecutive_errs < 5 {
            match do_frame(&pico, timebase, &sink, fs, &fft_trace, &data_tx, last_fundamental, do_dynamic_frequency) {
                Err(e) if e.is::<SendError<PlotCommand>>() => { break; }
                Err(e) if e.is::<PicoError>()              => { eprintln!("PicoScope error occurred: {e}"); consecutive_errs += 1; continue; }
                Err(e)                                     => { eprintln!("Error occurred: {e}");           consecutive_errs += 1; continue; }
                Ok(new_fundamental)                        => { last_fundamental = new_fundamental; }
            }

            while let Ok(_) = toggle_rx.try_recv() {
                do_dynamic_frequency = !do_dynamic_frequency;
            }
            
            consecutive_errs = 0;
        }

        if consecutive_errs == 5 { eprintln!("Too many consecutive errors. Exiting."); drop(sink); }
        logger.stop_logging(data_tx);
    });

    
    let listener = thread::spawn(move || {
        loop {
            let mut line = String::new();
            let _ = stdin().read_line(&mut line);

            if toggle_tx.send(()).is_err() { break; }
        }
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

    data_gathering.join().unwrap();
    eprintln!("Press enter to finish.");
    listener.join().unwrap();
}
