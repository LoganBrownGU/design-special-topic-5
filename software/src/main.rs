use std::{thread::{self, sleep}, time::Duration};

use liveplot::{AutoFitConfig, LivePlotConfig, PlotPoint, channel_plot, run_liveplot};

use crate::pico::pico_new;

mod signal_processing;
mod pico;

fn main() {
    let (sink, rx) = channel_plot();
    
    let sample_rate = 1000;
    let (ptx, prx) = pico_new(sample_rate);

    let t_step: f64 = 1.0 / sample_rate as f64;
    let t = thread::spawn(move || {
        let trace = sink.create_trace("Pico Signal", None);
        let mut n: f64 = 0.0;
        for _ in 0..60 {
            let v = prx.receive();
            if v.is_none() { continue; }
            let v = v.unwrap();
            
            for s in v {
                let _ =  sink.send_point(&trace, PlotPoint { x: n * t_step, y: s as f64 });
                n += 1.0; 
            }
            
            sleep(Duration::from_secs(1));
        }
    });

    let mut config = LivePlotConfig::default();
    config.time_window_secs = 60.0;
    config.auto_fit = AutoFitConfig {
        auto_fit_to_view: true,
        keep_max_fit: true,
    };
    config.headline = Some("Basic plotting idek".to_string());
    run_liveplot(rx, config).unwrap();
    ptx.join();
    t.join().unwrap();
}
