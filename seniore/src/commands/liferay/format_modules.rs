use crate::util::{command, runnable::Runnable};
use clap::Parser;

/// Format the code of the given list of modules.
#[derive(Parser)]
pub struct Command {
    modules: Vec<String>,
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let gradlew = super::get_portal_item_path("/gradlew");

        for module in &self.modules {
            let module_path = &super::get_module_path(module).expect(module);
            if super::is_osgi_module(module_path) {
                command::run(module_path, &(gradlew.to_owned() + " formatSource"));
            } else {
                println!("\"{}\" is not an osgi module", module);
            }
        }
        Ok(())
    }
}
