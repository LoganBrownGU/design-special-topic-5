use std::{thread::sleep, time::Duration};

use crate::pico::{PicoRx, PicoTx, pico_new};

mod signal_processing;
mod graph;
mod pico;

fn main() {
    let (mut ptx, prx) = pico_new();

    for _ in 0..60 {
        let _ = prx.receive();

        sleep(Duration::from_secs(1));
    }
}
