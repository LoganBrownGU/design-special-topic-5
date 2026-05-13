use crate::pico::Pico;

mod signal_processing;
mod pico;
mod data_source;

fn main() {
    let pico = Pico::new().unwrap();

    println!("{:?}", Pico::get_fs_and_buf(1000));
}
