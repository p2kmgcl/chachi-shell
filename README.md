```
      _                _     _            _          _ _
     | |              | |   (_)          | |        | | |
  ___| |__   __ _  ___| |__  _ ______ ___| |__   ___| | |
 / __| '_ \ / _` |/ __| '_ \| |______/ __| '_ \ / _ \ | |
| (__| | | | (_| | (__| | | | |      \__ \ | | |  __/ | |
 \___|_| |_|\__,_|\___|_| |_|_|      |___/_| |_|\___|_|_|
```

Development environment boilerplate.<br>
**Last full execution** on _June 1st, 2020_ on _Manjaro Linux x64_

> **Before install**, check that the install playbook variables
> are ok (username, project path, etc).

## Development environment (not provided by playbook)

- VSCode ([download](https://code.visualstudio.com/) and [sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) [configuration](https://gist.github.com/p2kmgcl/4af6fbc8d6ae3da54ff861b389465cce))
- [Seniore](https://github.com/p2kmgcl/seniore)
- [Page Editor Dev Server](https://github.com/p2kmgcl/page-editor-dev-server)

## Programming fonts (not provided by playbook)

- [Cascadia Code](https://github.com/microsoft/cascadia-code)
- [Fira Code](https://github.com/tonsky/FiraCode)
- [Hack](https://sourcefoundry.org/hack/)
- [IBM Plex](https://www.ibm.com/plex/)
- [Inconsolata](https://github.com/googlefonts/Inconsolata)
- [Iosevka](https://typeof.net/Iosevka/)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- [Noto](https://www.google.com/get/noto/)
- [Victor Mono](https://rubjo.github.io/victor-mono/)

## Liferay notes

- Liferay Loader full dependency graph:
  ```
  Control Panel -> Configuration -> System Settings -> Infrastructure ->
  Javascript Loader -> Explain Module Resolutions
  ```
- Format source all changes in branch:
  ```
  $ cd portal-impl
  $ ant format-source-current-branch
  ```
- Create language files:
  ```
  buildLang
  ```
- Format code:
  ```
  formatSource
  ```
- Run FrontEnd tests:
  ```
  packageRunTest
  ```
- Toggle jQuery:
  ```
  Product menu -> Configuration -> System settings -> Third party -> jQuery
  ```
- IE11 polyfills:
  ```
  IETopHeadDynamicInclude.java
  ```
- Run poshi tests locally ([docs](https://liferay-learn-poshi.readthedocs.io/en/latest/intro/liferay-functional-testing.html)):
  ```
  ant -f build-test.xml run-selenium-test -Dtest.class=FileName#TestName
  ```
