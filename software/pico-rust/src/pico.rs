#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused)]

include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

pub type PicoFrequency = pico_frequency_t;
pub type PicoTime = pico_frequency_t;
pub type PicoSample = pico_sample_t;
pub type PicoTimebase = pico_timebase_t;

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
}

impl Drop for Pico {
    fn drop(&mut self) {
        unsafe { pico_destroy(&mut self.inner); }
    }
}
