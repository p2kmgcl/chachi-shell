pub trait Runnable {
    fn run(&self) -> Result<(), String>;
}
