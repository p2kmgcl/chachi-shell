![Terminal screenshot](https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/preview.png)

## ⛰️ Minimal environment

1. Add a new SSH key.
2. Install: `curl fzf git nano ripgrep tree`
3. Install [Autojump](https://github.com/wting/autojump#name).
4. Clone this project in `~/Projects/chachi-shell`
5. `ln -s ~/Projects/chachi-shell/config/editorconfig ~/.editorconfig`
6. `ln -s ~/Projects/chachi-shell/config/gitconfig ~/.gitconfig`

## 🎬 UI

1. Cleanup your system. I am using **Manjaro KDE**.
2. Choose a **nice** wallpaper (take your time, this is important).
3. Configure terminal emulator.
4. Choose a nice font, currently using **IBM Plex Mono** everywhere.
5. Choose a browser, currently using **Google Chrome**.
6. Choose an editor I am using three of them right now:
   - **IntelliJ Ultimate** for work, as I need a powerful IDE that handles JS and a large Java project.
     My settings are synchronized with a JetBrains account.
   - **Visual Studio Code** for other stuff (smaller projects, personal stuff).
     I use [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) extension.
   - **NeoVIM** for quick hacks (although my configuration is prepared to handle more complex things).

## 🧑‍💻 Tools from me to me

- [seniore](https://github.com/p2kmgcl/seniore) to manage pull requests.
- [holi](https://github.com/p2kmgcl/holi) as quick notes (post-it alternative).
- [page-editor-dev-server](https://github.com/p2kmgcl/page-editor-dev-server) until we have something more stable.

## 🕶️ Awesome apps

- [mdp](https://github.com/visit1985/mdp): CLI written in Python to run text based presentations in terminal.
- [marp](https://marp.app/): Markdown presentation ecosystem, including editor extensions and PDF export.

## 🦀 Rust

1. `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

## 🦕 Deno

1. `curl -fsSL https://deno.land/x/install/install.sh | sh`

## 🪟 Tmux

1. Install `tmux`
2. `ln -s ~/Projects/chachi-shell/config/tmux.conf ~/.tmux.conf`
3. `git clone https://github.com/tmux-plugins/tpm.git ~/.tmux.tpm`
4. Open a terminal and run `Prefix+I` to install TMUX plugins.

## 📟 ZSH

1. Install `zsh`
2. `ln -s ~/Projects/chachi-shell/config/zshrc ~/.zshrc`
3. `git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh`
4. `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions`
5. Set ZSH as default interpreter (`chsh --shell $(which zsh) $(whoami)`).

## 🐋 Docker

1. Install [Docker](https://docs.docker.com/engine/install/).
2. Install [Docker Compose](https://docs.docker.com/compose/install/).
3. Add user to `docker` group (`sudo usermod -a -G docker $(whoami)`).

## 🧻 NVM (Node Version Manager)

1. Install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
2. Set default NodeJS: `nvm install 16 && nvm use 16 && nvm alias default 16 && npm i -g npm yarn`

## 🥸 NeoVIM

> Install desired language environments (NodeJS, Java, etc.) before running
> `PlugUpdate`, as they might be required.

1. Install `neovim`
2. `ln -s ~/Projects/chachi-shell/nvim ~/.config/nvim`
3. Install [VIM Plug](https://github.com/junegunn/vim-plug)
4. `PlugClean`, `PlugUpdate`, `UpdateRemotePlugins`

## 🌶️ Rofi

1. Install [`rofi`](https://github.com/davatorium/rofi)
2. Add `rofi -matching fuzzy -combi-modi "window#drun" -show combi -modi combi` shortcut (Alt+Space)

## 📚 Wiki?

- `docker exec [CONTAINER] --it [COMMAND]`
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

## 🧠 Linux environment from scratch

### 1. Previous investigation

For the first steps, I am going to follow the [ArchLinux](https://wiki.archlinux.org/title/installation_guide) installation wiki. I have tried it some years ago, and it gives an usable installation with a minimum amount of packages installed.

> __Nice information extracted from the [FAQ](https://wiki.archlinux.org/title/Frequently_asked_questions)__:
> - Only supports x86_64 architecture
> - Uses [systemd](https://wiki.archlinux.org/title/Systemd) as service manager.
> - `/bin`, `/sbin` and `/usr/sbin` are symbolic links to `/usr/bin`; `/lib` and `/lib64` are symbolic links to `/usr/lib`; [more info about filesystem hierarchy](https://man.archlinux.org/man/file-hierarchy.7).
> - `pacman -Qlq package_name` gives information about an installed package.
> - `systemd-boot` is used to manage a UEFI motherboard.
> - `xdg-user-dirs-update.service` takes care of creating user directories like "downloads" or "music". This might be enabled by default by the window manager.
> - ACPI events (power buttons, laptop lid...) can be managed with systemd.
> - Firewall is not enabled by default, but iptables can be enabled and should work.
> - By default it only supports english "standard" keyboard layout.
> - `tab-completion` needs to be enabled.

#### Loading only needed modules

As described in [general recomendations > booting > hardware auto-recognition](https://wiki.archlinux.org/title/General_recommendations), udev and Xorg take care of loading all necesary modules when booting, but this can be configured manually. I should look which modules should be loaded on boot, and try replacing Xorg display server protocol with Wayland.

Maybe I don't need to start a display manager (aka login screen) and just run `X` after logging in. I should look for information about this.

#### Multimedia

Archlinux wiki says that ALSA should work by default, but that other sound servers like PulseAudio and PipeWire offer additional features. I should check which are these differences and if it makes sense to use PipeWire/PulseAudio instead of ALSA.

#### Systemd

It not only manages services, but also sockets, mount points, etc. If no extension is specified when naming a unit, it will default to `.service`. By default it operates on system units (`--system` flag doesn't need to be specified). `--user` can be used to manage user units.

There is a table with some common commands in the [systemd arch wiki](https://wiki.archlinux.org/title/Systemd#Basic_systemctl_usage).

#### System maintenance

[Archlinux wiki](https://wiki.archlinux.org/title/System_maintenance)

---

Maybe window manager:
- Install `i3` and [`rofi`](https://github.com/davatorium/rofi).
- `mkdir -p ~/.config/i3 && ln -s ~/Projects/chachi-shell/i3/config ~/.config/i3/config`

Pending things:
- Check sway, to be used with Wayland
- Intel drivers
- Bluetooth
- Wifi
- Webcam
- Microphone
- Login manager
- Window manager
- File manager
- Password wallet
- Flatpak
- Authy

---

## 💙 Liferay

1. Install [OracleJDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
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
12. `git clone https://github.com/liferay/liferay-binaries-cache-2017.git ~/Projects/community-portal/liferay-binaries-cache-2017`
13. `git clone https://github.com/liferay/liferay-binaries-cache-2020.git ~/Projects/community-portal/liferay-binaries-cache-2020`
14. `buildLiferayPortal`
15. `cd ~/Projects/community-portal/bundles && ln -s ../config/portal-ext.properties portal-ext.properties`
16. `git clone https://github.com/holatuwol/liferay-intellij ~/Projects/community-portal/liferay-intellij`
17. `cd ~/Projects/community-portal/liferay-portal && ../liferay-intellij/intellij`

### 🔥 **Build portal drama**

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
- Liferay<=7.0 supports MySQL<=5.7 using driver `com.mysql.jdbc.Driver` (newer versions will fail)
- Liferay<=6.7 supports MySQL<=5.5 using driver `com.mysql.jdbc.Driver` (newer versions will fail)
- [Run Java tests with Ant](https://grow.liferay.com/people?p_p_id=com_liferay_wiki_web_portlet_WikiPortlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&_com_liferay_wiki_web_portlet_WikiPortlet_struts_action=%2Fwiki%2Fview&_com_liferay_wiki_web_portlet_WikiPortlet_redirect=%2Fpeople%3Fp_p_id%3Dmorelikethisportlet_INSTANCE_XyekCsVnINzd%26p_p_lifecycle%3D2%26p_p_state%3Dnormal%26p_p_mode%3Dview%26p_p_resource_id%3Dget_search_results%26p_p_cacheability%3DcacheLevelPage%26_morelikethisportlet_INSTANCE_XyekCsVnINzd_currentURL%3D%252Fpeople%253Fp_p_id%253Dcom_liferay_wiki_web_portlet_WikiPortlet%2526p_p_lifecycle%253D0%2526p_p_state%253Dnormal%2526p_p_mode%253Dview%2526_com_liferay_wiki_web_portlet_WikiPortlet_struts_action%253D%25252Fwiki%25252Fview%2526_com_liferay_wiki_web_portlet_WikiPortlet_pageResourcePrimKey%253D330720%2526p_r_p_http%25253A%25252F%25252Fwww.liferay.com%25252Fpublic-render-parameters%25252Fwiki_nodeName%253DGrow%2526p_r_p_http%25253A%25252F%25252Fwww.liferay.com%25252Fpublic-render-parameters%25252Fwiki_title%253DLiferay%252BPortal%252BUnit%252BAnd%252BIntegration%252BTests&_com_liferay_wiki_web_portlet_WikiPortlet_pageResourcePrimKey=211858&p_r_p_http%3A%2F%2Fwww.liferay.com%2Fpublic-render-parameters%2Fwiki_nodeName=Grow&p_r_p_http%3A%2F%2Fwww.liferay.com%2Fpublic-render-parameters%2Fwiki_title=How+to+Debug+Unit+or+Integration+Test+Running+with+Ant): `ant test-method -Dtest.class=JSONUtilTest -Dtest.methods=testCacafutiNiceParty -Djunit-debug=true`
