#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

use std::{f64, sync::{Arc, mpsc::{Receiver, Sender, channel}}, thread::{self, JoinHandle, sleep}, time::Duration};

use pico_sdk::{common::{PicoChannel, PicoCoupling, PicoRange}, device::PicoDevice, prelude::{DeviceEnumerator, NewDataHandler, ToStreamDevice}};

use crate::data_source::DataSource;


pub struct PicoPacket(Vec<i16>);

pub struct Pico {
    device: PicoDevice,
    raw_handle: i16,
}

impl Pico {
    pub fn new() -> Self {
        let enumerator = DeviceEnumerator::new();
        let device = enumerator.enumerate()
            .into_iter().flatten()
            .next().expect("No Picoscope was found.")
            .open().expect("Failed to open Picoscope.");

        let handle = device.handle.lock().unwrap();
        println!("raw handle: {handle}");
        Pico { device, raw_handle: handle }
    }
    
    pub fn open_channel(&self, sample_rate: u32, done_rx: Receiver<()>, pico_channel: PicoChannel) -> (PicoTx, PicoRx) {
        let (tx, rx) = channel();
        (PicoTx::new(self, tx, done_rx, sample_rate, pico_channel), PicoRx::new(rx))
    }
}

pub struct PicoRx {
    rx: Receiver<PicoPacket>,
}

pub struct PicoTx {
    t: JoinHandle<()>,
    _handler: Arc<dyn NewDataHandler>, // need to keep a ref to the handler to make sure it's not dropped
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
    fn new(parent: &Pico, tx: Sender<PicoPacket>, done_rx: Receiver<()>, sample_rate: u32, channel: PicoChannel) -> Self {

        struct PicoHandler { tx: Sender<PicoPacket>, channel: PicoChannel }
        impl NewDataHandler for PicoHandler {
            fn handle_event(&self, se: &pico_sdk::prelude::StreamingEvent) {
                let data = se.channels[&self.channel].samples.clone();
                se.channels[&CHANNEL_IN_USE].multiplier;
                let result = self.tx.send(PicoPacket(data));
                if result.is_err() {
                     eprintln!("Failed to send sample: {}.", result.unwrap_err().to_string());
                }
            }
        }
        
        let handler = Arc::new(PicoHandler { tx, channel });
        let streaming_device = parent.device.clone().into_streaming_device();
        streaming_device.enable_channel(channel, PicoRange::X1_PROBE_100MV, PicoCoupling::DC);
        streaming_device.new_data.subscribe(handler.clone());
        Self { t: thread::spawn(move || {
            streaming_device.start(sample_rate).expect("Failed to start Picoscope streaming.");       
            while let Err(_) = done_rx.recv() {}
            streaming_device.stop();
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


type PulseFrequency = f64;
pub struct PicoAWG {
    handle: JoinHandle<()>
}

const AWG_BUFFER_SIZE: f64 = 4096.0;
const DDS_FREQUENCY:   f64 = 48e6;
const PHASE_ACC_SIZE:  f64 = 2u64.pow(32) as f64;

fn generate_wave(pf: PulseFrequency) -> (Vec<u8>, u32) {
   
    let delta = (PHASE_ACC_SIZE * pf) / DDS_FREQUENCY;

    let mut awg_buf = vec![0u8; AWG_BUFFER_SIZE as usize];

    let time_per_sample = 1.0 / (pf * AWG_BUFFER_SIZE);
    let pulse_width = (50e-6 / time_per_sample).max(1.0) as usize;
    
    let pulse_start_idx = AWG_BUFFER_SIZE as usize / 2 - pulse_width / 2;
    let pulse_end_idx   = AWG_BUFFER_SIZE as usize / 2 + pulse_width / 2;

    for i in pulse_start_idx..pulse_end_idx { awg_buf[i] = u8::MAX / 2; }

    (awg_buf, delta as u32)
}

impl PicoAWG {
    pub fn new(parent: &Pico, rx: Receiver<PulseFrequency>) -> Self {
        let raw_handle = parent.raw_handle;
        Self { handle: thread::spawn(move || { unsafe {
            let mut buf = [0u8; AWG_BUFFER_SIZE as usize];
            while let Ok(pf) = rx.recv() {
                let t = generate_wave(pf);
                buf.copy_from_slice(t.0.as_slice()); let delta = t.1;
                // println!("{raw_handle}\t0\t{}\t{delta}\t{delta}\t0\t0\tptr\t{}\t{enPS2000SweepType_PS2000_UP}\t0", 2e6, buf.len() as i32);
                // let result = ps2000_set_sig_gen_arbitrary(
                //     raw_handle, 
                //     0, 
                //     2e6 as u32, 
                //     delta, delta, 
                //     0, 0, 
                //     buf.as_mut_ptr(), buf.len() as i32, 
                //     enPS2000SweepType_PS2000_UP, 0
                // );
                
                pico_awg(raw_handle);
                // println!("{:?}, {}", buf.as_mut_ptr(), buf[buf.len() / 2]);
            }
        }}) }
    }

    pub fn join(self) {
        self.handle.join().unwrap();
    }
}
