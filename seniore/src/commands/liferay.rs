use crate::util::{command, tmp};
use std::{env, fs, path, time};

pub fn build_lang() {
    command::run(
        &get_module_path("portal-language-lang").unwrap(),
        &get_portal_item_path("/gradlew"),
        &vec!["formatSource"],
    );

    command::run(
        &get_module_path("portal-language-lang").unwrap(),
        &get_portal_item_path("/gradlew"),
        &vec!["buildLang"],
    );

    command::run(
        &get_module_path("portal-language-lang").unwrap(),
        &get_portal_item_path("/gradlew"),
        &vec![
            "clean",
            "deploy",
            "-Dbuild=portal",
            "-Dnodejs.node.env=development",
        ],
    );
}

pub fn get_module_path(module: &str) -> Option<path::PathBuf> {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");

    if module.starts_with(portal_path.as_str()) {
        return Some(path::PathBuf::from(module));
    } else {
        for module_path in get_module_list() {
            if module_path.to_str().unwrap().contains(module) {
                return Some(module_path);
            }
        }
    }

    None
}

pub fn get_module_list() -> Vec<path::PathBuf> {
    fn is_osgi_module(directory_path: &path::PathBuf) -> bool {
        fs::read_dir(directory_path).map_or(false, |mut children| {
            children.any(|child_result| {
                child_result.map_or(false, |child| {
                    child.file_type().unwrap().is_file() && child.file_name() == "bnd.bnd"
                })
            })
        })
    }

    let mut modules: Vec<path::PathBuf> = Vec::new();

    fn add_modules(modules: &mut Vec<path::PathBuf>, basedir: &path::PathBuf) {
        let children = fs::read_dir(basedir).unwrap();

        for child in children.flatten() {
            if child.file_type().unwrap().is_dir() {
                add_modules(modules, &child.path());
                if is_osgi_module(&child.path()) {
                    modules.push(child.path());
                }
            }
        }
    }

    add_modules(&mut modules, &get_portal_item_path("/modules/apps"));

    modules
}

pub fn deploy_modules(modules: &Vec<String>) {
    for module in modules {
        let module_path = get_module_path(module.as_str()).unwrap();
        let module_name = get_module_name(&module_path);

        command::run(
            &module_path,
            &get_portal_item_path("/gradlew"),
            &vec!["clean", "deploy", "-Dbuild=portal"],
        );

        tmp::write_file(&module_name, get_module_duration(&module_path).to_string()).unwrap();
    }
}

pub fn format_modules(modules: &Vec<String>) {
    for module in modules {
        command::run(
            &get_module_path(module.as_str()).unwrap(),
            &get_portal_item_path("/gradlew"),
            &vec!["formatSource"],
        );
    }
}

pub fn update_modules_cache() {
    for module_path in get_updated_modules() {
        let module_name = get_module_name(&module_path);
        tmp::write_file(&module_name, get_module_duration(&module_path).to_string()).unwrap();
        println!("{}", module_path.to_str().unwrap());
    }
}

fn get_module_name(module_path: &path::Path) -> String {
    format!(
        "liferay-module-name--{}",
        module_path.to_str().unwrap().split('/').last().unwrap()
    )
}

fn get_directory_duration(directory_path: &path::PathBuf) -> u128 {
    let children = fs::read_dir(directory_path);

    if children.is_err() {
        return u128::MIN;
    }

    let mut directory_duration = u128::MIN;

    for child in children.unwrap().flatten() {
        let file_type = child.file_type().unwrap();

        let child_duration = if file_type.is_file() {
            fs::metadata(child.path())
                .unwrap()
                .modified()
                .unwrap()
                .duration_since(time::SystemTime::UNIX_EPOCH)
                .unwrap()
                .as_millis()
        } else {
            get_directory_duration(&child.path())
        };

        if child_duration > directory_duration {
            directory_duration = child_duration;
        }
    }

    directory_duration
}

fn get_module_duration(module_path: &path::Path) -> u128 {
    let mut src_path = module_path.to_path_buf();
    src_path.push("src");
    get_directory_duration(&src_path)
}

fn get_updated_modules() -> Vec<path::PathBuf> {
    let mut updated_modules = Vec::new();

    for module_path in get_module_list() {
        let duration = get_module_duration(&module_path);

        let latest_duration =
            tmp::read_file(get_module_name(&module_path).as_str()).unwrap_or("".to_string());

        if duration.to_string() != latest_duration {
            updated_modules.push(module_path);
        }
    }

    updated_modules
}

pub fn print_updated_modules() {
    for module_path in get_updated_modules() {
        println!("{}", module_path.to_str().unwrap());
    }
}

fn get_portal_item_path(item_path: &str) -> path::PathBuf {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let resolved_path = portal_path + item_path;

    return path::Path::new(resolved_path.as_str())
        .canonicalize()
        .expect(item_path);
}
