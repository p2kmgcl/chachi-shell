mod build_lang;
mod format_modules;
mod get_updated_modules;
mod update_modules_cache;

use std::fs::read_dir;
use std::env;
use crate::util::runnable::Runnable;
use clap::{Parser, Subcommand};

/// liferay-portal related tasks (source formatting, deployment, etc.).
#[derive(Parser)]
pub struct Command {
    #[command(subcommand)]
    command: Subcommands,
}

#[derive(Subcommand)]
enum Subcommands {
    BuildLang(build_lang::Command),
    FormatModules(format_modules::Command),
    GetUpdatedModules(get_updated_modules::Command),
    UpdateModulesCache(update_modules_cache::Command),
}

impl Runnable for Command {
    fn run(&self) -> Result<(), String> {
        match &self.command {
            Subcommands::BuildLang(build_lang) => build_lang.run(),
            Subcommands::FormatModules(format_modules) => format_modules.run(),
            Subcommands::GetUpdatedModules(get_updated_modules) => get_updated_modules.run(),
            Subcommands::UpdateModulesCache(update_modules_cache) => update_modules_cache.run(),
        }
    }
}

const NOT_OSGI_MODULES: &[&str] = &["portal-impl", "portal-kernel"];
const LAST_COMMIT_FILE_NAME: &str = "liferay-portal-last-commit";

fn get_module_list() -> Vec<String> {
    let mut modules: Vec<String> = Vec::new();

    fn add_modules(modules: &mut Vec<String>, basedir: &String) {
        let children = read_dir(basedir).expect(basedir);

        for child in children.flatten() {
            if child.file_type().unwrap().is_dir() {
                let child_path: String = child.path().to_str().unwrap().to_string();

                add_modules(modules, &child_path);

                if is_osgi_module(&child_path) {
                    modules.push(child_path);
                }
            }
        }
    }

    add_modules(&mut modules, &get_portal_item_path("/modules/apps"));
    modules
}

fn get_module_path(module: &str) -> Option<String> {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");

    if module.starts_with(&portal_path) && is_osgi_module(module) {
        return Some(module.to_string());
    }

    get_module_list()
        .into_iter()
        .find(|module_path| module_path.contains(module))
}

fn is_osgi_module(directory_path: &str) -> bool {
    if NOT_OSGI_MODULES
        .iter()
        .any(|not_osgi_module| directory_path.ends_with(not_osgi_module))
    {
        return false;
    }

    read_dir(directory_path).map_or(false, |mut children| {
        children.any(|child_result| {
            child_result.map_or(false, |child| {
                child.file_type().unwrap().is_file() && child.file_name() == "bnd.bnd"
            })
        })
    })
}

fn get_portal_item_path(item_path: &str) -> String {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");

    if item_path.starts_with(&portal_path) {
        item_path.to_string()
    } else if item_path.starts_with('/') {
        portal_path + item_path
    } else {
        portal_path + "/" + item_path
    }
}
