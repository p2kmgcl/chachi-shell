use std::{
    env,
    path::{Path, PathBuf},
    time::SystemTime,
    u128,
};

use crate::util::command;
use crate::util::tmp;

pub fn build_lang() {
    command::run(
        &get_portal_item_path("/modules/apps/portal-language/portal-language-lang/"),
        &get_portal_item_path("/gradlew"),
        &vec!["formatSource"],
    );

    command::run(
        &get_portal_item_path("/modules/apps/portal-language/portal-language-lang/"),
        &get_portal_item_path("/gradlew"),
        &vec!["buildLang"],
    );

    command::run(
        &get_portal_item_path("/modules/apps/portal-language/portal-language-lang/"),
        &get_portal_item_path("/gradlew"),
        &vec!["clean", "deploy", "-Dbuild=portal"],
    );
}

pub fn deploy_updated_modules() {
    let updated_modules = get_updated_modules();

    println!("Found {} module(s).", updated_modules.len());

    for module_path in updated_modules {
        command::run(
            &module_path,
            &get_portal_item_path("/gradlew"),
            &vec!["clean", "deploy", "-Dbuild=portal"],
        );
    }

    println!("All modules deployed.");
}

pub fn update_modules_cache() {
    let updated_modules = get_updated_modules();
    println!("{} module(s) updated.", updated_modules.len());
}

fn get_updated_modules() -> Vec<PathBuf> {
    fn is_osgi_module(directory_path: &PathBuf) -> bool {
        std::fs::read_dir(directory_path).map_or(false, |mut children| {
            children.any(|child_result| {
                child_result.map_or(false, |child| {
                    child.file_type().unwrap().is_file() && child.file_name() == "bnd.bnd"
                })
            })
        })
    }

    fn file_duration(file_path: &PathBuf) -> Result<u128, Box<dyn std::error::Error>> {
        Ok(std::fs::metadata(file_path)?
            .modified()?
            .duration_since(SystemTime::UNIX_EPOCH)?
            .as_millis())
    }

    fn get_module_duration(module_path: &PathBuf) -> u128 {
        let mut src_path = module_path.clone();

        src_path.push("src");

        file_duration(&src_path).unwrap_or(u128::MAX)
    }

    fn find_updated_modules(directory_path: &PathBuf) -> Vec<PathBuf> {
        let mut updated_modules: Vec<PathBuf> = Vec::new();

        let children = std::fs::read_dir(directory_path)
            .unwrap()
            .map(|child_result| child_result.unwrap());

        for child in children {
            if child.file_type().unwrap().is_dir() {
                let module_path = child.path();

                for child_module in find_updated_modules(&module_path) {
                    updated_modules.push(child_module);
                }

                if is_osgi_module(&module_path) {
                    let module_name = module_path.to_str().unwrap().replace("/", "-");
                    let duration = get_module_duration(&module_path);
                    let tmp_file_name = format!("liferay-module-cache-{}", module_name);

                    let latest_duration =
                        tmp::read_file(tmp_file_name.as_str()).unwrap_or("".to_string());

                    if duration.to_string() != latest_duration {
                        updated_modules.push(module_path);
                        tmp::write_file(tmp_file_name.as_str(), duration.to_string()).unwrap();
                    }
                }
            }
        }

        return updated_modules;
    }

    return find_updated_modules(&get_portal_item_path("/modules/apps"));
}

fn get_portal_item_path(item_path: &str) -> PathBuf {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let resolved_path = portal_path.clone() + item_path;

    return Path::new(resolved_path.as_str())
        .canonicalize()
        .expect(item_path);
}
