use std::thread;
use liveplot::{LivePlotConfig, PlotPoint, channel_plot, run_liveplot};

use crate::{pico::{Pico, PicoFrequency, PicoSample, PicoTime}};

mod signal_processing;
mod pico;

fn main() {

    let (sink, rx) = channel_plot();
    let signal_trace = sink.create_trace("signal", Some("something idek"));
    let fft_trace = sink.create_trace("FFT", Some("something idek"));

    let t = thread::spawn(move || {
        let pico = Pico::new().unwrap();
        let (fs, timebase) = pico.get_fs_and_timebase(3000, 500).expect("Unable to select a timebase.");

        eprintln!("Gathering samples at {fs}Hz. Timebase = {timebase}.");
        for _ in 0..100 {
            let mut tbuf = vec![0 as PicoTime;   fs as usize];
            let mut sbuf = vec![0 as PicoSample; fs as usize];
            pico.gather_samples(timebase, &mut tbuf, &mut sbuf).expect("Unable to perform read.");
            
            sink.clear_data(&signal_trace).expect("Unable to clear current data");
            sink.clear_data(&fft_trace).expect("Unable to clear current data");
            for p in tbuf.iter().zip(&sbuf).map(|(a, b)| PlotPoint { x: *a as f64 / 1e9, y: (*b as f64) / (PicoSample::MAX as f64) } ) {
                sink.send_point(&signal_trace, p).expect("Unable to send point.");
            }

            let fft = signal_processing::fft(&sbuf);
            let fft = fft[0..fft.len()/2].to_vec();
            let (fundamental, max) = fft.iter().enumerate().fold((0, f64::MIN), |p0, p1| if p0.1 > *p1.1 { p0 } else { (p1.0, *p1.1) });
            for p in tbuf.iter().zip(&fft).map(|(a, b)| PlotPoint { x: *a as f64 / 1e9, y: *b / max } ) {
                sink.send_point(&fft_trace, p).expect("Unable to send point.");
            }

            eprint!("fundamental: {fundamental}Hz     \r");
            pico.generate_wave(fundamental as PicoFrequency, 0.1).expect("Unable to create wave.");
        }
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
