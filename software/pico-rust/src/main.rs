use crate::pico::Pico;

mod signal_processing;
mod pico;
mod data_source;

fn main() {
    let pico = Pico::new().unwrap();

    let (fs, timebase) = pico.get_fs_and_timebase(10000, 2560).unwrap();
    println!("{} {}", fs, timebase);
}
