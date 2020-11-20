```
      _                _     _            _          _ _
     | |              | |   (_)          | |        | | |
  ___| |__   __ _  ___| |__  _ ______ ___| |__   ___| | |
 / __| '_ \ / _` |/ __| '_ \| |______/ __| '_ \ / _ \ | |
| (__| | | | (_| | (__| | | | |      \__ \ | | |  __/ | |
 \___|_| |_|\__,_|\___|_| |_|_|      |___/_| |_|\___|_|_|
```

Development environment boilerplate.<br>
**Last full execution** on _November 20th, 2020_ on _Fedora 32 x64_

![Terminal screenshot](https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/preview.png)

## First steps

1. Cleanup your system
1. Choose a wallpaper
1. Choose a font
1. Choose a browser

These are some nice fonts:

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
   - `alacritty`
   - `autojump`
   - `curl`
   - `docker`
   - `fzf`
   - `git`
   - `nano`
   - `ripgrep`
   - `tmux`
   - `tree`
   - `zsh`
1. `chsh --shell /bin/zsh $(whoami)`
1. `ssh-keygen`
1. `mkdir -p ~/Projects`
1. `git clone git@github.com:p2kmgcl/chachi-shell.git ~/Projects/chachi-shell`

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

## Liferay

1. Install OracleJDK 8
1. Ensure `/usr/lib/jvm/default-java` points to Java home
1. Ensure `/usr/lib/jvm/default-ant` points to ANT home
1. Install Apache ANT
1. `npm install --global gradle-launcher`
1. `mkdir -p ~/Projects/community-portal`
1. `ln -s ~/Projects/chachi-shell/liferay ~/Projects/community-portal/config`
1. `cd ~/Projects/community-portal && ln -s config/liferay-editorconfig .editorconfig`
1. `git clone git@github.com:p2kmgcl/liferay-portal.git ~/Projects/community-portal/liferay-portal`
1. `cd ~/Projects/community-portal/liferay-portal && git remote add upstream https://github.com/liferay/liferay-portal`
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
