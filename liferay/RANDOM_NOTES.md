# Random notes

- Liferay Loader full dependency graph:
  `Control Panel -> Configuration -> System Settings -> Infrastructure -> Javascript Loader -> Explain Module Resolutions`
- Format source all changes in branch:
  `cd ~/Projects/community-portal/liferay-portal/portal-impl && ant format-source-current-branch`
- Create language files: `gradlew buildLang`
- Format code: `gradlew formatSource`
- Run FrontEnd tests: `gradlew packageRunTest`
- Toggle jQuery:
  `Product menu -> Configuration -> System settings -> Third party -> jQuery`
- IE11 polyfills: `IETopHeadDynamicInclude.java`
- Run poshi tests locally
  ([docs](https://liferay-learn-poshi.readthedocs.io/en/latest/intro/liferay-functional-testing.html 'https://liferay-learn-poshi.readthedocs.io/en/latest/intro/liferay-functional-testing.html')):
  `ant -f build-test.xml run-selenium-test -Dbrowser.chrome.bin.file=/path/to/chrome/binary -Dtest.class=FileName#TestName`
  - Specific chromium releases can be downloaded from
    [cypress.io](https://chromium.cypress.io/ 'https://chromium.cypress.io/').
  - If tests doesn't run, try emptying `bundles/logs` directory, but keeping the
    directory itself.
- CSS RTL Conversion is made here: `frontend-css-rtl-servlet` and
  `CSSRTLConverter.java`
- Fragment bundler rendering process: `FragmentEntryLinkModelListener.java`
- Upgrade database:
  `cd ~/Projects/community-portal/bundles/tools/portal-tools-db-upgrade-client && ./db_upgrade.sh`
- Connect to telnet: `telnet localhost 11311`
- Liferay<=7.0 supports MySQL<=5.7 using driver `com.mysql.jdbc.Driver` (newer
  versions will fail).
  `ant test-method -Dtest.class=JSONUtilTest -Dtest.methods=testCacafutiNiceParty -Djunit-debug=true`
- Running integration tests:
  `gradlew testIntegration --tests com.liferay.cacafuti.test.CacafutiTest`
