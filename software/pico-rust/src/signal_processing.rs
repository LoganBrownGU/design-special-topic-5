use rustfft::{FftPlanner, num_complex::{Complex, ComplexFloat}};

use crate::pico::PicoSample;

pub fn fft(samples: &Vec<PicoSample>) -> Vec<f64> {
    let mut complex_samples = samples.iter().map(|x| Complex::<f64> {re: *x as f64, im: 0.0}).collect::<Vec<Complex<f64>>>();
    let fft = FftPlanner::new().plan_fft_forward(complex_samples.len());
    fft.process(&mut complex_samples);
    drop(fft); 
    return complex_samples.iter().map(|c| c.abs()).collect::<Vec<f64>>()
}
