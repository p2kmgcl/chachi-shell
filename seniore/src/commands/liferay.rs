use crate::util::{command, tmp};
use std::{env, error, fs, path, time, u128};

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

fn get_updated_modules() -> Vec<path::PathBuf> {
    fn is_osgi_module(directory_path: &path::PathBuf) -> bool {
        fs::read_dir(directory_path).map_or(false, |mut children| {
            children.any(|child_result| {
                child_result.map_or(false, |child| {
                    child.file_type().unwrap().is_file() && child.file_name() == "bnd.bnd"
                })
            })
        })
    }

    fn file_duration(file_path: &path::PathBuf) -> Result<u128, Box<dyn error::Error>> {
        Ok(fs::metadata(file_path)?
            .modified()?
            .duration_since(time::SystemTime::UNIX_EPOCH)?
            .as_millis())
    }

    fn find_updated_modules(directory_path: &path::PathBuf) -> Vec<path::PathBuf> {
        let mut updated_modules: Vec<path::PathBuf> = Vec::new();

        let children = fs::read_dir(directory_path)
            .unwrap()
            .map(|child_result| child_result.unwrap());

        for child in children {
            if child.file_type().unwrap().is_dir() {
                let module_path = child.path();

                for child_module in find_updated_modules(&module_path) {
                    updated_modules.push(child_module);
                }

                if is_osgi_module(&module_path) {
                    let duration = {
                        let mut src_path = module_path.to_path_buf();
                        src_path.push("src");
                        file_duration(&src_path).unwrap_or(u128::MAX)
                    };

                    let module_name = module_path.to_str().unwrap().replace('/', "-");
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

        updated_modules
    }

    find_updated_modules(&get_portal_item_path("/modules/apps"))
}

fn get_portal_item_path(item_path: &str) -> path::PathBuf {
    let portal_path = env::var("LIFERAY_PORTAL_PATH").expect("LIFERAY_PORTAL_PATH env variable");
    let resolved_path = portal_path + item_path;

    return path::Path::new(resolved_path.as_str())
        .canonicalize()
        .expect(item_path);
}
