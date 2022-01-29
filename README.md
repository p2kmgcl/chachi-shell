![Terminal screenshot](https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/preview.png)

- [Setup](#setup)
  - [Custom interface](#custom-interface)
  - [Awesome apps](#awesome-apps)
  - [Programming languages](#programming-languages)
  - [Tmux](#tmux)
  - [ZSH](#zsh)
  - [Docker](#docker)
  - [NeoVIM](#neovim)
- [Random notes](#random-notes)
- [Nice fonts](#nice-fonts)
- [Archlinux adventure](#archlinux-adventure)
  - [About systemd](#about-systemd)
  - [Microcode updates](#microcode-updates)
  - [The adventure](#the-adventure)
    - [Enable network](#enable-network)
    - [Create new user](#create-new-user)
    - [Enable sudo](#enable-sudo)
    - [Bluetooth](#bluetooth)
    - [AUR](#aur)
    - [Sway](#sway)
    - [Flatpak](#flatpak)
    - [Audio](#audio)
    - [Brightness](#brightness)
  - [Maintenance](#maintenance)
  - [Pending things](#pending-things)
- [Liferay](#liferay)
  - [Build portal drama](#build-portal-drama)
  - [Random Liferay notes](#random-liferay-notes)

## Setup

1. Install `openssh`.
2. Add a new SSH key.
3. Install: `curl fzf git nano ripgrep tree`
4. Install [Autojump](https://github.com/wting/autojump#name).
5. Clone this project in `~/Projects/chachi-shell`
6. `ln -s ~/Projects/chachi-shell/config/editorconfig ~/.editorconfig`
7. `ln -s ~/Projects/chachi-shell/config/gitconfig ~/.gitconfig`

### Custom interface

1. Cleanup your system. I am using **Archlinux**.
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

### Awesome apps

- [seniore](https://github.com/p2kmgcl/seniore) to manage pull requests.
- [holi](https://github.com/p2kmgcl/holi) as quick notes (post-it alternative).
- [page-editor-dev-server](https://github.com/p2kmgcl/page-editor-dev-server) until we have something more stable.
- [mdp](https://github.com/visit1985/mdp): CLI written in Python to run text based presentations in terminal.
- [marp](https://marp.app/): Markdown presentation ecosystem, including editor extensions and PDF export.

### Programming languages

- Rust: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Deno: `curl -fsSL https://deno.land/x/install/install.sh | sh`
- NodeJS: install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating) and run `nvm install 16 && nvm use 16 && nvm alias default 16 && npm i -g npm yarn`
- Python

### Tmux

1. Install `tmux`
2. `ln -s ~/Projects/chachi-shell/config/tmux.conf ~/.tmux.conf`
3. `git clone https://github.com/tmux-plugins/tpm.git ~/.tmux.tpm`
4. Open a terminal and run `Prefix+I` to install TMUX plugins.

### ZSH

1. Install `zsh`
2. `ln -s ~/Projects/chachi-shell/config/zshrc ~/.zshrc`
3. `git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh`
4. `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions`
5. Set ZSH as default interpreter (`chsh --shell $(which zsh) $(whoami)`).

### Docker

1. Install [Docker](https://docs.docker.com/engine/install/).
2. Install [Docker Compose](https://docs.docker.com/compose/install/).
3. Add user to `docker` group (`sudo usermod -a -G docker $(whoami)`).

### NeoVIM

> Install desired language environments (NodeJS, Java, etc.) before running
> `PlugUpdate`, as they might be required.

1. Install `neovim`
2. `ln -s ~/Projects/chachi-shell/nvim ~/.config/nvim`
3. Install [VIM Plug](https://github.com/junegunn/vim-plug)
4. `PlugClean`, `PlugUpdate`, `UpdateRemotePlugins`

## Random notes

- `docker exec [CONTAINER] --it [COMMAND]`
- `mysqldump -h [HOST] -u [USER] -p[PASSWORD] [DATABASE_NAME] > dump.sql`
- `docker cp [CONTAINER]:[CONTAINER_PATH] [HOST_PATH]`

## Nice fonts

- [Cascadia Code](https://github.com/microsoft/cascadia-code)
- [Fira Code](https://github.com/tonsky/FiraCode)
- [Hack](https://sourcefoundry.org/hack/)
- [IBM Plex](https://www.ibm.com/plex/)
- [Inconsolata](https://github.com/googlefonts/Inconsolata)
- [Iosevka](https://typeof.net/Iosevka/)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- [Noto](https://www.google.com/get/noto/)
- [Victor Mono](https://rubjo.github.io/victor-mono/)

## ArchLinux Adventure

For the first steps, I am going to follow the [ArchLinux](https://wiki.archlinux.org/title/installation_guide) installation wiki. I have tried it some years ago, and it gives an usable installation with a minimum amount of packages installed.

**Wiki FAQ**:

- Only supports x86_64 architecture
- Uses [systemd](https://wiki.archlinux.org/title/Systemd) as service manager.
- `/bin`, `/sbin` and `/usr/sbin` are symbolic links to `/usr/bin`; `/lib` and `/lib64` are symbolic links to `/usr/lib`; [more info about filesystem hierarchy](https://man.archlinux.org/man/file-hierarchy.7).
- `pacman -Qlq package_name` gives information about an installed package.
- `systemd-boot` is used to manage a UEFI motherboard.
- `xdg-user-dirs-update.service` takes care of creating user directories like "downloads" or "music". This might be enabled by default by the window manager.
- ACPI events (power buttons, laptop lid...) can be managed with systemd.
- Firewall is not enabled by default, but iptables can be enabled and should work.
- By default it only supports english "standard" keyboard layout.
- `tab-completion` needs to be enabled.

### About systemd

Systemd not only manages services, but also sockets, mount points, etc. If no extension is specified when naming a unit, it will default to `.service`. By default it operates on system units (`--system` flag doesn't need to be specified). `--user` can be used to manage user units.

There is a table with some common commands and how unit files work in the [systemd arch wiki](https://wiki.archlinux.org/title/Systemd#Basic_systemctl_usage).

In order to run privileged actions (like shutdown or reboot) as an unprivileged user, and without using sudo to spawn a whole privileged process. Polkit can be installed and configured. Most desktop environments have authentication agents that communicate with polkit.

With `/etc/systemd/logind.conf` ACPI events can be configured, and `/etc/systemd/sleep.conf` to configure how system is suspended.

### Microcode updates

`amd-ucode` or `intel-ucode` package needs to be installed in order to get microcode updates. Linux Kernel will take care of applying these updates when they come, but it needs to be enabled in the bootloader.

In the case of systemd-boot, a `/boot/loader/entries/entry.conf` file needs to be updated with the microcode information, for example:

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
...
```

And then ensure that the latest microcode is available in the EFI system partition, mounted as `/boot`,

### The adventure

> - `iwctl device list`
> - `iwctl station [wlan0] scan`
> - `iwctl station [wlan0] connect [SSID]` (`/var/lib/iwd/*` is created)
> - `systemctl reboot/poweroff/suspend/hybrid-sleep`

Follow basic archlinux installation, taking into account:

- `zsh` needs to be installed (if wanted)
- `iwd` needs to be installed manually
- `[intel/amd]-ucode` might need to be installed manually
- [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot#Installing_the_EFI_boot_manager) configuration needs to be generated

#### Enable network

> - `systemctl [enable/disable/start/stop/restart] [unit]`
> - `systemctl --type=[service/target/...]`

`/etc/systemd/network/25-wireless.network`:

```
[Match]
Name=wlan0

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
```

Enable these units:

- `iwd.service`: manage wireless network
- `systemd-networkd.service`: manage network configuration
- `systemd-resolved.service`: local DNS manager

#### Create new user

> - `useradd -m -s /usr/bin/zsh [user]`

#### Enable sudo

> `sudo -lU [user]`: checks if user can use sudo
> `usermod -a -G [group] [user]`: adds [user] to [group]

- Install `sudo`
- Creating `/etc/sudoers.d/00-sudo-group`

```
sudo ALL=(ALL) ALL
```

#### Bluetooth

> - `lsmod`: list loaded kernel modules
> - `rfkill list`: checks laptop device blocking (wifi, bluetooth, etc.)

1. Install `bluez bluez-utils`
2. Check that `btusb` kernel module is loaded
3. Start/enable `bluetooth.service` unit

bluetoothctl commands:

- `power on`
- `scan on`
- `agent on`
- `devices`
- `pair [MAC]`
- `trust [MAC]`
- `connect [MAC]`

`/var/lib/bluetooth/[MAC]/[MAC]` directory is created.

To enable connecting on boot, editing `/etc/bluetooth/main.conf`:

```
[Policy]
AutoEnable=true
```

#### AUR

- `pacman -S --needed base-devel` is needed
- Download files (ex. `git clone https://aur.archlinux.org/package_name.git`)
- Run `makepkg -s -i -r -c`

> Use `yay` for easier maintenance

#### Sway

> - Sway is a compositor for wayland
> - `swaymsg -t get_outputs` list outputs

- Install `sway clipman alacritty`
- Install `sway-launcher-desktop` from AUR

> Installing `xorg-xwayland` is necessary for
> better compatibility with _old_ X11 only applications.

- `mkdir -p ~/.config/alacritty && ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.config/alacritty/alacritty.yml`
- `mkdir -p ~/.config/sway && ln -s ~/Projects/chachi-shell/config/sway.config ~/.config/sway/config`
- Run `sway`

#### Flatpak

- Install `flatpak`

> It request installing some `xdg-desktop-portal-impl` implementation. I guess this is the library
> that will be used to render the UI of some FlatPak packages. I found that xdg-desktop-portal-wlr
> has been created to probide a wlroots (modules to build a wayland compositor) friendly environment.

- Install both:

  - `xdg-desktop-portal-wlr`
  - `xdg-desktop-portal-gtk`

- Adding needed environment variables to Sway config:

```
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
```

> It requires to install a pipewire-session-manager, looks like wireplumber is recommended.

```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

Some apps, like Google Chrome, are only available on the beta repo:

```
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
```

#### Audio

- Install `pipewire pipewire-alsa pipewire-pulse pipewire-jack`
- Install `helvum` and `pavucontrol` to manage audio
- Install `playerctl`

#### Brightness

- Install `brightnessctl`

### Maintenance

- Installing `archlinux-keyring` updates gpg keys storage
- [Archlinux wiki](https://wiki.archlinux.org/title/System_maintenance)

### Pending things

- Run sway on login
- Webcam
- Microphone
- File manager
- Password wallet
- Suspend/reboot
- Update sway on HDMI add/remove
- Screenshot/screencast
- Sway lockscreen
- Stop media on sleep

## Liferay

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

### Build portal drama

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

### Random liferay notes

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
