use crate::util::runnable::Runnable;
use crate::util::command::run;
use clap::Parser;
use super::{get_portal_item_path, get_module_path, is_osgi_module};

/// Format the code of the given list of modules.
#[derive(Parser)]
pub struct Command {
    modules: Vec<String>,
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let gradlew = get_portal_item_path("/gradlew");

        for module in &self.modules {
            let module_path = &get_module_path(module).expect(module);
            if is_osgi_module(module_path) {
                run(module_path, &(gradlew.to_owned() + " formatSource"));
            } else {
                println!("\"{}\" is not an osgi module", module);
            }
        }
        Ok(())
    }
}
