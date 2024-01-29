use crate::util::runnable::Runnable;
use crate::util::command::get_output;
use crate::util::tmp::read_file;
use clap::Parser;
use super::{get_portal_item_path, is_osgi_module, LAST_COMMIT_FILE_NAME};
use std::env;
use std::collections::HashSet;
use std::path::Path;

/// Gets the list of modules that have been updated since last UpdateModulesCache run.
#[derive(Parser)]
pub struct Command {}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        let portal_path =
            env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
        let run_git_command = |command: &str| get_output(&portal_path, command);

        let branch_files = {
            let last_commit = read_file(LAST_COMMIT_FILE_NAME).unwrap_or("master".to_string());
            let current_commit = run_git_command("git log -n 1 --pretty=format:%H");

            run_git_command(&format!(
                "git diff --name-only {}..{}",
                last_commit, current_commit
            ))
        };

        let local_files = {
            let output = run_git_command("git status --porcelain");

            output
                .lines()
                .map(|line| line.to_string().chars().skip(3).collect::<String>())
                .collect::<Vec<String>>()
                .join("\n")
        };

        let changed_files = branch_files + "\n" + &local_files;

        let module_set = changed_files
            .lines()
            .filter_map(|file| {
                let mut maybe_file_path = Some(get_portal_item_path(&format!("/{}", file)));

                while let Some(file_path) = maybe_file_path {
                    if is_osgi_module(&file_path) {
                        return Some(file_path);
                    }

                    maybe_file_path = Path::new(&file_path)
                        .parent()
                        .map(|parent| parent.to_str().unwrap().to_string());
                }

                None
            })
            .collect::<HashSet<String>>();

        println!(
            "{}",
            module_set.into_iter().collect::<Vec<String>>().join("\n")
        );

        Ok(())
    }
}
