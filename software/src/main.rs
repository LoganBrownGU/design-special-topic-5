use std::{thread::sleep, time::Duration};

use crate::pico::pico_new;

mod signal_processing;
mod graph;
mod pico;

fn main() {
    let (ptx, prx) = pico_new();

    let mut n: usize = 0;
    for _ in 0..60 {
        n += if let Some(v) = prx.receive() { v.len() } else { 0 };
        println!("{n}");

        sleep(Duration::from_secs(1));
    }

    ptx.join();
}
