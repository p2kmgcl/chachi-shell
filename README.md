```
      _                _     _            _          _ _
     | |              | |   (_)          | |        | | |
  ___| |__   __ _  ___| |__  _ ______ ___| |__   ___| | |
 / __| '_ \ / _` |/ __| '_ \| |______/ __| '_ \ / _ \ | |
| (__| | | | (_| | (__| | | | |      \__ \ | | |  __/ | |
 \___|_| |_|\__,_|\___|_| |_|_|      |___/_| |_|\___|_|_|
```

Development environment boilerplate.<br>
**Last full execution** on _December 17th, 2020_ on _Manjaro x64_

![Terminal screenshot](https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/preview.png)

## First steps

1. Clone this project in `~/Projects/chachi-shell`
1. Cleanup your system
1. Choose a wallpaper
1. Choose a font
1. Choose a browser

## Archlinux install

1. Change keyboard layout with `loadkeys us/es`
1. Use `ip link` to see network devices and configure wifi with [iwctl](https://wiki.archlinux.org/index.php/Iwd#iwctl)
1. `timedatectl set-ntp true` to use network time and `timedatectl status` to check time
1. `cfdisk` is a nice partition manager
   > GPT to use with modern system<br />
   > `/mnt/boot` EFI partition of 500MB<br />
   > `/mnt` Root partition<br />
   > `fdisk -l` to list partitions
1. `mkfs.ext4` or `mkfs.fat -F32` or `mkswap` to format partitions
1. `mount /dev/* /mount-point` to mount partitions
1. `swapon /dev/*` to mount swap
1. Choose best mirrors with:
   ```
   reflector --verbose --country Spain,France,Germany --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
   ```
1. `pacstrap /mnt base base-devel linux linux-firmware` to install base packages
1. `genfstab -U /mnt >> /mnt/etc/fstab`
1. `arch-chroot /mnt`
1. `ln -sf /usr/share/zoneinfo/* /etc/localtime` to change timezone
1. `hwclock --systohc` to sync time
1. `pacman -S neovim`
1. `nvim /etc/locale.gen` and uncomment locales (`en_US.UTF-8 UTF-8` and `es_ES.UTF-8 UTF-8`)
1. `locale-gen`
3. `echo "LANG=en_US.UTF-8" > /etc/locale.conf` to set default locale
4. `echo -e "KEYMAP=us\nFONT=ter-132n" > /etc/vconsole.conf` to set layout and font
5. `/etc/hostname` with HOST_NAME
6. `/etc/hosts`
   ```
   127.0.0.1 localhost
   ::1       localhost
   127.0.1.1 HOST_NAME.localdomain HOST_NAME
   ```
1. `passwd`
1. `pacman -S grub efibootmgr dosfstools os-prober mtools`
1. `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck`
1. `grub-mkconfig -o /boot/grub/grub.cfg`

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

## Minimal environment

1. `ln -s ~/Projects/chachi-shell/config/editorconfig ~/.editorconfig`
1. `ln -s ~/Projects/chachi-shell/config/gitconfig ~/.gitconfig`
1. `ln -s ~/Projects/chachi-shell/config/zshrc ~/.zshrc`
1. `ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.alacritty.yml`
1. Install:
   - [Alacritty](https://github.com/alacritty/alacritty#alacritty)
   - [autojump](https://github.com/wting/autojump#name)
   - [docker](https://docs.docker.com/engine/install/)
   - `curl`
   - `fzf`
   - `git`
   - `nano`
   - `ripgrep`
   - `tmux`
   - `tree`
   - `zsh`
1. `chsh --shell $(which zsh) $(whoami)`
1. `ssh-keygen`

## oh-my-zsh

1. `git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh`
1. `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions`

## tmux config

1. `ln -s ~/Projects/chachi-shell/config/tmux.conf ~/.tmux.conf`
1. `git clone https://github.com/tmux-plugins/tpm.git ~/.tmux.tpm`
1. `Prefix+I` to install plugins

## NVM

1. Install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
1. Set default NodeJS: `nvm install 14 && npm use 14 && nvim alias default 14`

## NeoVIM

1. Install `neovim`
1. `ln -s ~/Projects/chachi-shell/nvim ~/.config/nvim`
1. Install [VIM Plug](https://github.com/junegunn/vim-plug)
1. `PlugClean`, `PlugUpdate`, `UpdateRemotePlugins`

## Wiki?

- `mysqldump -h [HOST] -u [USER] -p[PASSWORD] [DATABASE_NAME] > dump.sql`
- `docker cp [CONTAINER]:[CONTAINER_PATH] [HOST_PATH]`

## Liferay

1. Install OracleJDK 8
1. Install Apache ANT
1. Install Maven
1. Ensure `/usr/lib/jvm/default-java` points to Java home
1. Ensure `/usr/lib/jvm/default-ant` points to ANT home
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

### Random notes

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

- Upgrade database:
  ```
  cd bundles/tools/portal-tools-db-upgrade-client
  ./db_upgrade.sh
  ```
- Connect to telnet:
  ```
  telnet localhost 11311
  ```
- Liferay 6.2 supports MySQL<=5.5 (newer versions will fail)
