use std::{thread, time::Duration};

use liveplot::{LivePlotConfig, PlotPoint, channel_plot, run_liveplot};

use crate::pico::{Pico, PicoSample, PicoTime};

mod signal_processing;
mod pico;
mod data_source;

fn main() {

    let pico = Pico::new().expect("fauiled to open");
    pico.generate_wave(100, 0.1).expect("Failed to generate wave");
    eprintln!("Generated wave.");
    thread::sleep(Duration::from_secs(10));
    /* 
    let (sink, rx) = channel_plot();
    let trace = sink.create_trace("signal", Some("something idek"));

    let t = thread::spawn(move || {
        let pico = Pico::new().unwrap();
        let (fs, timebase) = pico.get_fs_and_timebase(3000, 500).expect("Unable to select a timebase.");

        eprintln!("Gathering samples at {fs}Hz. Timebase = {timebase}.");
        for _ in 0..100 {
            let mut tbuf = vec![0 as PicoTime;   fs as usize];
            let mut sbuf = vec![0 as PicoSample; fs as usize];
            pico.gather_samples(timebase, &mut tbuf, &mut sbuf).expect("Unable to perform read.");
            
            sink.clear_data(&trace).expect("Unable to clear current data");
            for p in tbuf.iter().zip(sbuf).map(|(a, b)| PlotPoint { x: *a as f64 / 1e9, y: b as f64 } ) {
                sink.send_point(&trace, p).expect("Unable to send point.");
            }
        }
    });

    let config = LivePlotConfig {
        time_window_secs: 4.0,
        auto_fit: liveplot::AutoFitConfig { auto_fit_to_view: true, keep_max_fit: true },
        max_points: 1e6 as usize,
        y_unit: Some("V".to_string()),
       ..Default::default() 
    };
    run_liveplot(rx, config).expect("Unable to start plot.");

    t.join().unwrap();*/
}
