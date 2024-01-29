use crate::util::runnable::Runnable;
use crate::util::command::get_output;
use crate::util::tmp::write_file;
use clap::Parser;
use super::LAST_COMMIT_FILE_NAME;
use std::env;

/// Creates a checkpoint to check differences when running get-updated-modules.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let portal_path =
            env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");

        write_file(
            LAST_COMMIT_FILE_NAME,
            get_output(&portal_path, "git log -n 1 --pretty=format:%H"),
        );

        Ok(())
    }
}
