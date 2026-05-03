use std::{sync::{Arc, mpsc::{Receiver, Sender, channel}}, thread::{self, JoinHandle, Thread}};

use pico_sdk::{common::{PicoChannel, PicoCoupling, PicoRange}, prelude::{DeviceEnumerator, NewDataHandler, ToStreamDevice}};


pub struct PicoPacket(Vec<i16>);

pub struct PicoRx {
    rx: Receiver<PicoPacket>,
}

pub struct PicoTx {
    t: JoinHandle<()>,
}

pub fn pico_new() -> (PicoTx, PicoRx) {
    let (tx, rx) = channel();
    (PicoTx::new(tx), PicoRx::new(rx))
}

impl PicoRx {
    fn new(rx: Receiver<PicoPacket>) -> Self { 
        Self { rx }
    }

    pub fn receive(&self) -> Option<PicoPacket> {
        let data = self.rx.try_recv().ok()?;
        Some(data)
    }
}

impl PicoTx {
    fn new(tx: Sender<PicoPacket>) -> Self {
        let enumerator = DeviceEnumerator::new();
        let device = enumerator.enumerate()
            .into_iter().flatten()
            .next().expect("No Picoscope was found.")
            .open().expect("Failed to open Picoscope.")
            .into_streaming_device();

        device.enable_channel(PicoChannel::A, PicoRange::X1_PROBE_10V, PicoCoupling::DC);
        
        Self { t: thread::spawn(move || {
            struct PicoHandler { tx: Sender<PicoPacket> };
            impl NewDataHandler for PicoHandler {
                fn handle_event(&self, _: &pico_sdk::prelude::StreamingEvent) {
                    
                    self.tx.send(PicoPacket(vec![420, 69])).unwrap();
                }
            }
            
            let handler = Arc::new(PicoHandler { tx });
            device.new_data.subscribe(handler);
            device.start(1_000_000).expect("Failed to start Picoscope streaming.");
        }) }
    }
}
