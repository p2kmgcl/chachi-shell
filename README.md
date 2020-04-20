# Chachi shell

Ansible playbook with tasks to have a full configured environment.<br>
Last execution on Manjaro Linux x64

> Some roles have dependencies because they need some programs to be
> available in the system. That's why all roles are organized in
> `playbook.yml`, which ensure that dependencies are installed first.

## Liferay notes

### Random thoughts

- Changing `Control Panel -> Configuration -> System Settings -> Infrastructure -> Javascript Loader -> Explain Module Resolutions` make Liferay Loader print the hole dependency graph to the browser console.
- Running `ant format-source-current-branch` from `portal-impl` executes format source for all changes in current branch.

### Gradlew scripts

- `buildLang`.
- `formatSource`.
- `packageRunTest` run tests using portal's yarn binary.
