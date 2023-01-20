use std::{
    env,
    path::{Path, PathBuf},
    time::SystemTime,
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

pub fn update_deploy_cache() {
    fn is_osgi_module(directory_path: &PathBuf) -> bool {
        std::fs::read_dir(directory_path).map_or(false, |mut children| {
            children.any(|child_result| {
                child_result.map_or(false, |child| {
                    child.file_type().unwrap().is_file() && child.file_name() == "bnd.bnd"
                })
            })
        })
    }

    fn find_modules(directory_path: &PathBuf, callback: fn(&PathBuf) -> ()) {
        let children = std::fs::read_dir(directory_path)
            .unwrap()
            .map(|child_result| child_result.unwrap());

        for child in children {
            if child.file_type().unwrap().is_dir() {
                find_modules(&child.path(), callback);

                if is_osgi_module(&child.path()) {
                    callback(&child.path());
                }
            }
        }
    }

    fn file_duration(file_path: &PathBuf) -> u128 {
        std::fs::metadata(file_path)
            .unwrap()
            .modified()
            .unwrap()
            .duration_since(SystemTime::UNIX_EPOCH)
            .unwrap()
            .as_millis()
    }

    fn module_duration(module_path: &PathBuf) -> u128 {
        file_duration(&module_path)
    }

    find_modules(&get_portal_item_path("/modules/apps"), |module_path| {
        let module_name = module_path.to_str().unwrap().replace("/", "-");
        let duration = module_duration(&module_path);

        tmp::write_file(
            format!("liferay-module-cache-{}", module_name).as_str(),
            duration.to_string(),
        )
        .unwrap();
    });
}

fn get_portal_item_path(item_path: &str) -> PathBuf {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let resolved_path = portal_path.clone() + item_path;

    return Path::new(resolved_path.as_str())
        .canonicalize()
        .expect(item_path);
}
