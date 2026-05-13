
pub trait DataSource: Send {
    fn receive(&self) -> Option<Vec<i16>>;
}
