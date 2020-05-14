# Chachi shell

Ansible playbook with tasks to have a full configured environment.<br>
Last execution on Manjaro Linux x64

> Some roles have dependencies because they need some programs to be
> available in the system. That's why all roles are organized in
> `playbook.yml`, which ensure that dependencies are installed first.

## Liferay notes

- Changing `Control Panel -> Configuration -> System Settings -> Infrastructure -> Javascript Loader -> Explain Module Resolutions` make Liferay Loader print the hole dependency graph to the browser console.
- Running `ant format-source-current-branch` from `portal-impl` executes format source for all changes in current branch.
- `buildLang` creates language files
- `formatSource` formats all code in module
- `packageRunTest` run tests using portal's yarn binary.
- jQuery can be enabled/disabled in `Product menu -> Configuration -> System settings -> Third party -> jQuery`.
- IE11 polyfills are loaded in `IETopHeadDynamicInclude`.
- Run poshi tests locally:
    - TL;DR: `ant -f build-test.xml run-selenium-test -Dtest.class=FileName#TestName`
    - Docs: https://liferay-learn-poshi.readthedocs.io/en/latest/intro/liferay-functional-testing.html
