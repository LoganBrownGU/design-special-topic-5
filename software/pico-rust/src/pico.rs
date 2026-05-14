#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused)]

include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

pub type PicoFrequency = pico_frequency_t;
pub type PicoTime = pico_frequency_t;
pub type PicoSample = pico_sample_t;
pub type PicoTimebase = pico_timebase_t;
pub type PicoAwgValue = pico_awg_value_t;

pub struct Pico {
    inner: *mut pico
}

impl Pico {
    pub fn new() -> Option<Self> {
        let inner = unsafe { pico_new() };

        if inner.is_null() { None } else { Some(Self { inner }) }
    }

    pub fn get_fs_and_timebase(&self, fs: PicoFrequency, tolerance: PicoFrequency) -> Option<(PicoFrequency, PicoTimebase)> {
        let mut actual_fs: PicoFrequency = 0;
        let mut timebase: PicoTimebase = 0;
        
        let result = unsafe { pico_get_fs(self.inner, fs, tolerance, std::ptr::from_mut(&mut actual_fs), std::ptr::from_mut(&mut timebase)) };
        
        if result == 0 { None } else { Some((actual_fs, timebase)) }
    }

    pub fn gather_samples(&self, timebase: PicoTimebase, tbuf: &mut [PicoTime], sbuf: &mut [PicoSample]) -> Result<(), ()> {
        assert!(tbuf.len() == sbuf.len());
        let result = unsafe { pico_gather_samples(self.inner, timebase, tbuf.as_mut_ptr(), sbuf.as_mut_ptr(), tbuf.len()) };
        
        if result == 0 { Err(()) } else { Ok(()) }
    }

    pub fn generate_wave(&self, fundamental: PicoFrequency, duty_cycle: f64) -> Result<(), ()> {

        let mut buf: Vec<PicoAwgValue> = vec![0 as PicoAwgValue; AWG_BUFFER_SIZE];
        for (i, v) in buf.iter_mut().enumerate() {
            *v = if (i as f64) < (AWG_BUFFER_SIZE as f64 * duty_cycle) { 
                PicoAwgValue::MAX 
            } else { 
                PicoAwgValue::MIN 
            };
        } 
        
        let result = unsafe { pico_awg(self.inner, fundamental, buf.as_mut_ptr()) };
        
        return Ok(());
    }
}

impl Drop for Pico {
    fn drop(&mut self) {
        unsafe { pico_destroy(&mut self.inner); }
    }
}
