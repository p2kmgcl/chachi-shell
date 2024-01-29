use crate::util::runnable::Runnable;
use crate::util::command::run;
use super::{get_module_path, get_portal_item_path};
use clap::Parser;

/// Deploy the lang module to update translations.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let gradlew = get_portal_item_path("/gradlew");
        let path = get_module_path("portal-language-lang").expect("portal-language-lang");

        run(&path, &(gradlew.clone() + " formatSource"));
        run(&path, &(gradlew.clone() + " buildLang"));
        run(&path, &(gradlew + " clean deploy -Dbuild=portal"));

        Ok(())
    }
}
