use crate::util::{
    command,
    tmp::{read_file, write_file},
};
use std::{collections::HashSet, env, fs::read_dir, path::Path};

const NOT_OSGI_MODULES: &[&str] = &["portal-impl", "portal-kernel"];

const LAST_COMMIT_FILE_NAME: &str = "liferay-portal-last-commit";

pub fn build_lang() {
    let gradlew = get_portal_item_path("/gradlew");
    let path = get_module_path("portal-language-lang").expect("portal-language-lang");

    command::run(&path, &(gradlew.clone() + " formatSource"));
    command::run(&path, &(gradlew.clone() + " buildLang"));
    command::run(&path, &(gradlew + " clean deploy -Dbuild=portal"));
}

pub fn get_module_list() -> Vec<String> {
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

pub fn deploy_modules(modules: &Vec<String>) {
    let gradlew = get_portal_item_path("/gradlew");

    for module in modules {
        let module_path = &get_module_path(module).expect(module);
        if is_osgi_module(module_path) {
            command::run(
                module_path,
                &(gradlew.to_owned()
                    + " clean deploy -Dbuild=portal -Dnodejs.node.env=development"),
            );
        } else {
            println!("\"{}\" is not an osgi module", module);
        }
    }
}

pub fn format_modules(modules: &Vec<String>) {
    let gradlew = get_portal_item_path("/gradlew");

    for module in modules {
        let module_path = &get_module_path(module).expect(module);
        if is_osgi_module(module_path) {
            command::run(module_path, &(gradlew.to_owned() + " formatSource"));
        } else {
            println!("\"{}\" is not an osgi module", module);
        }
    }
}

pub fn update_modules_cache() {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");

    write_file(
        LAST_COMMIT_FILE_NAME,
        command::get_output(&portal_path, "git log -n 1 --pretty=format:%H"),
    );
}

pub fn get_updated_modules() {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let run_git_command = |command: &str| command::get_output(&portal_path, command);

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
