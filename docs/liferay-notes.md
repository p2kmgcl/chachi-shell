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

  > If tests doesn't run, try emptying `bundles/logs` directory.

  ```
  ant -f build-test.xml run-selenium-test -Dtest.class=FileName#TestName
  ```

- CSS RTL Conversion is made here:
  ```
  frontend-css-rtl-servlet
  CSSRTLConverter.java
  ```
- Feature flag:
  ```
  echo "key=value" >> osgi/configs/com.liferay.layout.content.page.editor.web.internal.configuration.FFLayoutContentPageEditorConfiguration.config
  ```
- [Fragment bundler rendering process](https://github.com/liferay/liferay-portal/blob/16072c46daa174cf23c143e456d829f183c95424/modules/apps/fragment/fragment-renderer-react-impl/src/main/java/com/liferay/fragment/renderer/react/internal/model/listener/FragmentEntryLinkModelListener.java#L135-L143)
