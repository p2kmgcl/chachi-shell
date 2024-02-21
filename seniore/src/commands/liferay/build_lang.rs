use crate::util::{command, runnable::Runnable};
use clap::Parser;

/// Deploy the lang module to update translations.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let gradlew = super::get_portal_item_path("/gradlew");
        let path = super::get_module_path("portal-language-lang").expect("portal-language-lang");

        command::run(&path, &(gradlew.clone() + " formatSource"));
        command::run(&path, &(gradlew.clone() + " buildLang"));
        command::run(&path, &(gradlew + " clean deploy -Dbuild=portal"));

        Ok(())
    }
}
