use std::{sync::mpsc::{Receiver, TryRecvError, channel}, thread::{self, JoinHandle, sleep}, time::Duration};

use liveplot::{AutoFitConfig, LivePlotConfig, PlotPoint, PlotSink, channel_plot, data::x_formatter::{DecimalFormatter, XFormatter}, run_liveplot};
use pico_sdk::common::PicoChannel;

use crate::{data_source::DataSource, pico::{MockPicoRx, Pico, PicoAWG}};

mod signal_processing;
mod pico;
mod data_source;

fn start_collector(parent: Pico, data_source: Box<dyn DataSource>, done: Receiver<()>, sink: PlotSink, sample_rate: usize) -> JoinHandle<()> {
    thread::spawn(move || {
        let trace = sink.create_trace("PicoScope Channel A Fourier Transform", None);
        let mut buf = Vec::with_capacity(sample_rate as usize);
        let (tx, rx) = channel();
        let awg = PicoAWG::new(&parent, rx);
        while let Err(TryRecvError::Empty) = done.try_recv() {
            let v = data_source.receive();
            if v.is_none() { continue; }
            let v = v.unwrap();
            
            for s in v {
                buf.push(s);
                if buf.len() == sample_rate as usize {
                    let mut fft = signal_processing::fft(&buf);
                    fft[0] = 0.0;
                    for (f, a) in fft.iter().enumerate() { let _ = sink.send_point(&trace, PlotPoint { x: f as f64, y: *a }); }

                    let max = fft[0..(fft.len()/2)].iter().enumerate().reduce(|a, b| if a.1 > b.1 { a } else { b }).unwrap();
                    tx.send(max.0 as f64).unwrap();
                    
                    buf.clear();
                }
            }
        }
        drop(tx);
        drop(parent);
        awg.join();
    })
}

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


    let pico = Pico::new();
    let (ptx, prx) = Pico::open_channel(&pico, sample_rate, plot_done_rx_0, PicoChannel::A);
    let mockprx = MockPicoRx { sample_rate: sample_rate as usize };

    let t = start_collector(pico, Box::new(prx), plot_done_rx_1, sink, sample_rate as usize);

    let mut config = LivePlotConfig::default();
    config.time_window_secs = sample_rate as f64;
    config.x_formatter = XFormatter::Decimal(DecimalFormatter::default());
    config.auto_fit = AutoFitConfig {
        auto_fit_to_view: true,
        keep_max_fit: true,
    };
    config.max_points = sample_rate as usize;
    config.headline = Some("Basic plotting idek".to_string());
    println!("Starting plotter...");
    run_liveplot(rx, config).unwrap();

    let _ = plot_done_tx_0.send(());
    let _ = plot_done_tx_1.send(());
    ptx.join();
    t.join().unwrap();
}
