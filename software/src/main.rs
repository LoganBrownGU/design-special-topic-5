use std::{sync::mpsc::{TryRecvError, channel}, thread::{self, sleep}, time::Duration};

use liveplot::{AutoFitConfig, LivePlotConfig, PlotPoint, channel_plot, data::x_formatter::{DecimalFormatter, XFormatter}, run_liveplot};

use crate::pico::pico_new;

mod signal_processing;
mod pico;

fn main() {
    let (sink, rx) = channel_plot();
    let (plot_done_tx_0, plot_done_rx_0) = channel();
    let (plot_done_tx_1, plot_done_rx_1) = channel();

    let args = std::env::args().collect::<Vec<String>>();
    let sample_rate = if args.len() >= 2 { 
        let sample_rate_str = args[1].clone();
        sample_rate_str.parse::<u32>().expect(format!("Sample rate ({sample_rate_str}) invalid.").as_str()) 
    } else {
        println!("Running with default sample rate of 1kHz.");
        1000
    };
    let (ptx, prx) = pico_new(sample_rate, plot_done_rx_0);

    let t_step: f64 = 1.0 / sample_rate as f64;
    let t = thread::spawn(move || {
        let trace = sink.create_trace("Pico Signal", None);
        let mut n: f64 = 0.0;
        while let Err(TryRecvError::Empty) = plot_done_rx_1.try_recv() {
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
    config.time_window_secs = 10.0;
    config.x_formatter = XFormatter::Decimal(DecimalFormatter::default());
    config.auto_fit = AutoFitConfig {
        auto_fit_to_view: true,
        keep_max_fit: true,
    };
    config.max_points = 10 * sample_rate as usize;
    config.headline = Some("Basic plotting idek".to_string());
    run_liveplot(rx, config).unwrap();

    plot_done_tx_0.send(()).unwrap();
    plot_done_tx_1.send(()).unwrap();
    ptx.join();
    t.join().unwrap();
}
