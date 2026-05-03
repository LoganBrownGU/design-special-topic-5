use rustfft::{FftPlanner, num_complex::{self, Complex}};


pub fn fft(samples: &Vec<i16>) -> Vec<i16> {
    let mut complex_samples = samples.iter().map(|x| Complex::<i16> {re: *x, im: 0}).collect::<Vec<Complex<i16>>>();
    let fft = FftPlanner::new().plan_fft_forward(complex_samples.len());
    fft.process(&mut complex_samples);
    drop(fft); 
    return complex_samples.iter().map(|c| c.re).collect::<Vec<i16>>()
}
