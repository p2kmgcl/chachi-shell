use crate::util::{command, runnable::Runnable, tmp};
use clap::Parser;
use std::env;

/// Creates a checkpoint to check differences when running get-updated-modules.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let portal_path =
            env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");

        tmp::write_file(
            super::LAST_COMMIT_FILE_NAME,
            command::get_output(&portal_path, "git log -n 1 --pretty=format:%H"),
        );

        Ok(())
    }
}
