# Liferay

- [page-editor-dev-server](https://github.com/p2kmgcl/page-editor-dev-server)
  until we have something more stable.
- [testing-fragments](https://github.com/p2kmgcl/testing-fragments)
- Some antivirus software.

## Setup

1. Install
   [OracleJDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
2. Install [Apache ANT](https://downloads.apache.org/ant/binaries/)
3. Install [Apache Maven](https://downloads.apache.org/maven/binaries/)
4. Ensure `/usr/lib/jvm/default-java` points to Java home
5. Ensure `/usr/lib/jvm/default-ant` points to ANT home
6. Ensure `/usr/lib/jvm/default-maven` points to Maven home
7. `mkdir -p ~/Projects/community-portal`
8. `ln -s ~/Projects/chachi-shell/liferay ~/Projects/community-portal/config`
9. `cd ~/Projects/community-portal && ln -s config/liferay-editorconfig .editorconfig`
10. `git clone git@github.com:p2kmgcl/liferay-portal.git ~/Projects/community-portal/liferay-portal`
11. `cd ~/Projects/community-portal/liferay-portal && git remote add upstream https://github.com/liferay/liferay-portal`
12. `git clone https://github.com/liferay/liferay-binaries-cache-2020.git ~/Projects/community-portal/liferay-binaries-cache-2020`
13. `buildLiferayPortal`
14. `cd ~/Projects/community-portal/bundles && ln -s ../config/portal-ext.properties portal-ext.properties`
15. `git clone https://github.com/holatuwol/liferay-intellij ~/Projects/community-portal/liferay-intellij`
16. `cd ~/Projects/community-portal/liferay-portal && ../liferay-intellij/intellij`

### Github Token for source format

Since 2023-04-13, SF is looks for vulnerabilities in build.gradle files. In
order to make this work, we need to generate a GitHub Legacy/Classic token
with the `read:repo_hook` permission and place it in `$HOME/github.token`.

https://github.com/settings/tokens/new

## Build portal drama

> If portal doesn't compile some steps must you follow,<br /> check this options
> each by each,<br /> and if it doesn't work<br /> go back to sleep.

- Update master and try again.
- git clean -fd
- git clean -fdX
- Reinstall Java, MySQL, Ant, Maven and Node.
- Try to use the latest docker nightly.
- Use this day to check bugs and PTRs.
- Tell someone to stream their computer and pair-program the whole day.
- Try on a brand-new pc.

## Random notes

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
  ([docs](https://liferay-learn-poshi.readthedocs.io/en/latest/intro/liferay-functional-testing.html)):
  `ant -f build-test.xml run-selenium-test -Dbrowser.chrome.bin.file=/path/to/chrome/binary -Dtest.class=FileName#TestName`.
  (Specific chromium releases can be downloaded from
  [cypress.io](https://chromium.cypress.io/)). (If tests doesn't run, try
  emptying `bundles/logs` directory)
- CSS RTL Conversion is made here: `frontend-css-rtl-servlet` and
  `CSSRTLConverter.java`
- Feature flag:
  `echo "key=value" >> ~/Projects/community-portal/bundles/osgi/configs/com.liferay.layout.content.page.editor.web.internal.configuration.FFLayoutContentPageEditorConfiguration.config`
- Fragment bundler rendering process: `FragmentEntryLinkModelListener.java`
- Upgrade database:
  `cd ~/Projects/community-portal/bundles/tools/portal-tools-db-upgrade-client && ./db_upgrade.sh`
- Connect to telnet: `telnet localhost 11311`
- Liferay<=7.0 supports MySQL<=5.7 using driver `com.mysql.jdbc.Driver` (newer
  versions will fail)
- Liferay<=6.7 supports MySQL<=5.5 using driver `com.mysql.jdbc.Driver` (newer
  versions will fail)
- [Run Java tests with Ant](https://grow.liferay.com/people?p_p_id=com_liferay_wiki_web_portlet_WikiPortlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&_com_liferay_wiki_web_portlet_WikiPortlet_struts_action=%2Fwiki%2Fview&_com_liferay_wiki_web_portlet_WikiPortlet_redirect=%2Fpeople%3Fp_p_id%3Dmorelikethisportlet_INSTANCE_XyekCsVnINzd%26p_p_lifecycle%3D2%26p_p_state%3Dnormal%26p_p_mode%3Dview%26p_p_resource_id%3Dget_search_results%26p_p_cacheability%3DcacheLevelPage%26_morelikethisportlet_INSTANCE_XyekCsVnINzd_currentURL%3D%252Fpeople%253Fp_p_id%253Dcom_liferay_wiki_web_portlet_WikiPortlet%2526p_p_lifecycle%253D0%2526p_p_state%253Dnormal%2526p_p_mode%253Dview%2526_com_liferay_wiki_web_portlet_WikiPortlet_struts_action%253D%25252Fwiki%25252Fview%2526_com_liferay_wiki_web_portlet_WikiPortlet_pageResourcePrimKey%253D330720%2526p_r_p_http%25253A%25252F%25252Fwww.liferay.com%25252Fpublic-render-parameters%25252Fwiki_nodeName%253DGrow%2526p_r_p_http%25253A%25252F%25252Fwww.liferay.com%25252Fpublic-render-parameters%25252Fwiki_title%253DLiferay%252BPortal%252BUnit%252BAnd%252BIntegration%252BTests&_com_liferay_wiki_web_portlet_WikiPortlet_pageResourcePrimKey=211858&p_r_p_http%3A%2F%2Fwww.liferay.com%2Fpublic-render-parameters%2Fwiki_nodeName=Grow&p_r_p_http%3A%2F%2Fwww.liferay.com%2Fpublic-render-parameters%2Fwiki_title=How+to+Debug+Unit+or+Integration+Test+Running+with+Ant):
  `ant test-method -Dtest.class=JSONUtilTest -Dtest.methods=testCacafutiNiceParty -Djunit-debug=true`
- `gradlew testIntegration --tests com.liferay.cacafuti.test.CacafutiTest`
