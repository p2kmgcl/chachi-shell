![Terminal screenshot](https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/preview.png)

## 🎬 First steps

1. Add a new SSH key.
1. Install: `curl fzf git nano ripgrep tmux tree zsh`.
1. Clone this project in `~/Projects/chachi-shell`.
1. Cleanup your system. I am using __Fedora__ with __Gnome__. __pop-shell__ gnome extension has an incredible
1. Choose a __nice__ wallpaper (take your time, this is important).
1. Choose a nice font, currently using __Noto Sans Mono__ everywhere.
1. Choose a browser, currently using __Google Chrome__.
1. Choose an editor I am using three of them right now:
   - __IntelliJ Ultimate__ for work, as I need a powerful IDE that handles JS and a large Java project.
     Actually I use VSCode keymaps, even on this IDE. My settings are synchronized with a JetBrains account.
   - __Visual Studio Code__ for other stuff (smaller projects, personal stuff).
     I use [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extension.
   - __NeoVIM__ for quick hacks (although my configuration is prepared to handle more complex things).

## 🧑‍💻 Tools from me to me

- [seniore](https://github.com/p2kmgcl/seniore) to manage pull requests.
- [holi](https://github.com/p2kmgcl/holi) as quick notes (post-it alternative).
- [page-editor-dev-server](https://github.com/p2kmgcl/page-editor-dev-server) until we have something more stable.

## ⛰️ Minimal environment

1. `ln -s ~/Projects/chachi-shell/config/editorconfig ~/.editorconfig`
1. `ln -s ~/Projects/chachi-shell/config/gitconfig ~/.gitconfig`
1. `ln -s ~/Projects/chachi-shell/config/zshrc ~/.zshrc`
1. `ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.alacritty.yml`
1. Install [Delta](https://github.com/dandavison/delta#installation).
1. Install [Alacritty](https://github.com/alacritty/alacritty#alacritty).
1. Install [Autojump](https://github.com/wting/autojump#name).
1. Install [Docker](https://docs.docker.com/engine/install/).
1. `git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh`
1. `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions`
1. `ln -s ~/Projects/chachi-shell/config/tmux.conf ~/.tmux.conf`
1. `git clone https://github.com/tmux-plugins/tpm.git ~/.tmux.tpm`
1. Set ZSH as default interpreter (`chsh --shell $(which zsh) $(whoami)`).
1. Good moment to restart so everything is set into place.
1. Open a terminal and run `Prefix+I` to install TMUX plugins.

## 🧻 NVM (Node Version Manager)

1. Install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
1. Set default NodeJS: `nvm install 14 && npm use 14 && nvim alias default 14`

## 🥸 NeoVIM

1. Install `neovim`
1. `ln -s ~/Projects/chachi-shell/nvim ~/.config/nvim`
1. Install [VIM Plug](https://github.com/junegunn/vim-plug)
1. `PlugClean`, `PlugUpdate`, `UpdateRemotePlugins`

## 📚 Wiki?

- `mysqldump -h [HOST] -u [USER] -p[PASSWORD] [DATABASE_NAME] > dump.sql`
- `docker cp [CONTAINER]:[CONTAINER_PATH] [HOST_PATH]`

## 🗛 Nice fonts

- [Cascadia Code](https://github.com/microsoft/cascadia-code)
- [Fira Code](https://github.com/tonsky/FiraCode)
- [Hack](https://sourcefoundry.org/hack/)
- [IBM Plex](https://www.ibm.com/plex/)
- [Inconsolata](https://github.com/googlefonts/Inconsolata)
- [Iosevka](https://typeof.net/Iosevka/)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- [Noto](https://www.google.com/get/noto/)
- [Victor Mono](https://rubjo.github.io/victor-mono/)

---

## 💙 Liferay

1. Install [OracleJDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
1. Install [Apache ANT](https://downloads.apache.org/ant/binaries/)
1. Install [Apache Maven](https://downloads.apache.org/maven/binaries/)
1. Ensure `/usr/lib/jvm/default-java` points to Java home
1. Ensure `/usr/lib/jvm/default-ant` points to ANT home
1. Ensure `/usr/lib/jvm/default-maven` points to Maven home
1. `npm install --global gradle-launcher`
1. `mkdir -p ~/Projects/community-portal`
1. `ln -s ~/Projects/chachi-shell/liferay ~/Projects/community-portal/config`
1. `cd ~/Projects/community-portal && ln -s config/liferay-editorconfig .editorconfig`
1. `git clone git@github.com:p2kmgcl/liferay-portal.git ~/Projects/community-portal/liferay-portal`
1. `cd ~/Projects/community-portal/liferay-portal && git remote add upstream https://github.com/liferay/liferay-portal`
1. `git clone https://github.com/liferay/liferay-binaries-cache-2017.git ~/Projects/community-portal/liferay-binaries-cache-2017`
1. `git clone https://github.com/liferay/liferay-binaries-cache-2020.git ~/Projects/community-portal/liferay-binaries-cache-2020`
1. `git clone https://github.com/holatuwol/liferay-intellij ~/Projects/community-portal/liferay-intellij`
1. `buildLiferayPortal`
1. `runLiferayPortal` and stop
1. `cd ~/Projects/community-portal/bundles && ln -s ../config/portal-ext.properties portal-ext.properties`


### 🔥 __Build portal drama__

> If portal doesn't compile some steps must you follow,<br />
> check this options each by each,<br />
> and if it doesn't work<br />
> go back to sleep.

- Update master and try again.
- git clean -fd
- git clean -fdX
- Reinstall Java, MySQL, Ant, Maven and Node.
- Try to use the latest docker nightly.
- Use this day to check bugs and PTRs.
- Tell someone to stream their computer and pair-program the whole day.
- Try on a brand-new pc.

### ⁉️ Random notes

- Liferay Loader full dependency graph: `Control Panel -> Configuration -> System Settings -> Infrastructure -> Javascript Loader -> Explain Module Resolutions`
- Format source all changes in branch: `cd ~/Projects/community-portal/liferay-portal/portal-impl && ant format-source-current-branch`
- Create language files: `gradlew buildLang`
- Format code: `gradlew formatSource`
- Run FrontEnd tests: `gradlew packageRunTest`
- Toggle jQuery: `Product menu -> Configuration -> System settings -> Third party -> jQuery`
- IE11 polyfills: `IETopHeadDynamicInclude.java`
- Run poshi tests locally ([docs](https://liferay-learn-poshi.readthedocs.io/en/latest/intro/liferay-functional-testing.html)):
  `ant -f build-test.xml run-selenium-test -Dtest.class=FileName#TestName`.
  (If tests doesn't run, try emptying `bundles/logs` directory)
- CSS RTL Conversion is made here: `frontend-css-rtl-servlet` and `CSSRTLConverter.java`
- Feature flag: `echo "key=value" >> ~/Projects/community-portal/bundles/osgi/configs/com.liferay.layout.content.page.editor.web.internal.configuration.FFLayoutContentPageEditorConfiguration.config`
- Fragment bundler rendering process: `FragmentEntryLinkModelListener.java`
- Upgrade database: `cd ~/Projects/community-portal/bundles/tools/portal-tools-db-upgrade-client && ./db_upgrade.sh`
- Connect to telnet: `telnet localhost 11311`
- Liferay 6.2 supports MySQL<=5.5 (newer versions will fail)
