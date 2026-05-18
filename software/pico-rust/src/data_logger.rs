use std::{fmt::format, fs::File, io::{BufWriter, Seek, Write}, sync::mpsc::{Receiver, Sender}, thread::{self, JoinHandle}, time::SystemTime};

use crate::pico::PicoSample;

pub struct DataPoint(pub f64, pub PicoSample);

pub struct DataLogger {
    handle: JoinHandle<()>,
}

fn write_data(data: &mut Vec<DataPoint>, fw: &mut BufWriter<File>)  {
    let content = data.iter().map(ToString::to_string).collect::<Vec<String>>().join("\n") + "\n";
    fw.write_all(&content.into_bytes()).unwrap();
    data.clear();
}

impl DataLogger {
    pub fn new(rx: Receiver<DataPoint>, log_path: String, capacity: usize) -> Result<Self, std::io::Error> {
        let mut fw = BufWriter::new(File::create(log_path)?);
        let handle = thread::spawn(move || {
            let mut data: Vec<DataPoint> = Vec::with_capacity(capacity);
            while let Ok(data_point) = rx.recv() {
                data.push(data_point);

                if data.len() < capacity { continue; }
               
                write_data(&mut data, &mut fw);
            }

            write_data(&mut data, &mut fw);
        });
        
        Ok(Self { handle })
    }

    pub fn stop_logging(self, tx: Sender<DataPoint>) {
        drop(tx);
        self.handle.join().unwrap();
    }
}

impl ToString for DataPoint {
    fn to_string(&self) -> String {
        format!("{} {}", self.0, self.1)
    }
}
