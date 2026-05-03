use std::{f64, sync::{Arc, mpsc::{Receiver, Sender, channel}}, thread::{self, JoinHandle, sleep}, time::Duration};

use pico_sdk::{common::{PicoChannel, PicoCoupling, PicoRange}, prelude::{DeviceEnumerator, NewDataHandler, ToStreamDevice}, sys::{ps2000, ps2000a::ps2000aBlockReady}};

use crate::data_source::DataSource;


pub struct PicoPacket(Vec<i16>);

pub struct PicoRx {
    rx: Receiver<PicoPacket>,
}

pub struct PicoTx {
    t: JoinHandle<()>,
    _handler: Arc<dyn NewDataHandler>, // need to keep a ref to the handler to make sure it's not dropped
}

pub fn pico_new(sample_rate: u32, done_rx: Receiver<()>) -> (PicoTx, PicoRx) {
    let (tx, rx) = channel();
    (PicoTx::new(tx, done_rx, sample_rate), PicoRx::new(rx))
}

impl PicoRx {
    fn new(rx: Receiver<PicoPacket>) -> Self { 
        Self { rx }
    }
}

impl DataSource for PicoRx {
    fn receive(&self) -> Option<Vec<i16>> {
        let mut v = Vec::new();
        while let Ok(mut packet) = self.rx.try_recv() {
            v.append(&mut packet.0);
        }
        Some(v)       
    }
}



const CHANNEL_IN_USE: PicoChannel = PicoChannel::A;
impl PicoTx {
    fn new(tx: Sender<PicoPacket>, done_rx: Receiver<()>, sample_rate: u32) -> Self {
        let enumerator = DeviceEnumerator::new();
        let device = enumerator.enumerate()
            .into_iter().flatten()
            .next().expect("No Picoscope was found.")
            .open().expect("Failed to open Picoscope.")
            .into_streaming_device();

        device.enable_channel(CHANNEL_IN_USE, PicoRange::X1_PROBE_100MV, PicoCoupling::DC);
        
        struct PicoHandler { tx: Sender<PicoPacket> }
        impl NewDataHandler for PicoHandler {
            fn handle_event(&self, se: &pico_sdk::prelude::StreamingEvent) {
                let data = se.channels[&CHANNEL_IN_USE].samples.clone();
                se.channels[&CHANNEL_IN_USE].multiplier;
                let result = self.tx.send(PicoPacket(data));
                if result.is_err() {
                     eprintln!("Failed to send sample: {}.", result.unwrap_err().to_string());
                }
            }
        }
        
        let handler = Arc::new(PicoHandler { tx });
        device.new_data.subscribe(handler.clone());
        Self { t: thread::spawn(move || {
            device.start(sample_rate).expect("Failed to start Picoscope streaming.");       
            while let Err(_) = done_rx.recv() {}
            device.stop();
        }), _handler: handler }
    }

    pub fn join(self) {
        self.t.join().unwrap();
    }
}




pub struct MockPicoRx {
    pub sample_rate: usize,
}

impl DataSource for MockPicoRx {
    fn receive(&self) -> Option<Vec<i16>> {
        sleep(Duration::from_millis(100));
        let mut samples = Vec::new();
        for i in 0..self.sample_rate {
            let t = i as f64 / self.sample_rate as f64;

            let om = 2.0 * f64::consts::PI * t;
            let y = (5.0*om).sin() + (10.0*om).sin();
            samples.push((y * i16::MAX as f64) as i16);
        }

        Some(samples)
    } 
}


pub struct PicoA {
    rx: Receiver<usize>,
    handle: JoinHandle<()>
}

impl PicoA {
    pub fn new(rx: Receiver<usize>) -> Self {
        
        let enumerator = DeviceEnumerator::new();
        let device = enumerator.enumerate()
            .into_iter().flatten()
            .next().expect("No Picoscope was found.")
            .open().expect("Failed to open Picoscope.");

        let handle = (unsafe { *device.handle.data_ptr() }).unwrap();
        
        Self { rx, handle: thread::spawn(move || {
            
        }) }
    }

    pub fn join(self) {
        self.handle.join().unwrap();
    }
}
