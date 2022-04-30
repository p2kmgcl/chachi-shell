# Development environment

## Setup

1. Install `openssh`.
2. Add a new SSH key.
3. Install: `curl fzf git jq nano ripgrep tree`
4. Install [Autojump](https://github.com/wting/autojump#name).
5. Clone this project in `~/Projects/chachi-shell`
6. `ln -s ~/Projects/chachi-shell/config/editorconfig ~/.editorconfig`
7. `ln -s ~/Projects/chachi-shell/config/gitconfig ~/.gitconfig`

### Custom interface

1. Cleanup your system. I am using **Archlinux**.
2. Choose a **nice** wallpaper (take your time, this is important).
3. Configure terminal emulator.
4. Choose a nice font, currently using **IBM Plex Mono** everywhere.
5. Choose a browser, currently using **Firefox**.
6. Choose an editor I am using three of them right now:
   - **IntelliJ Ultimate** for work, as I need a powerful IDE that handles JS
     and a large Java project. My settings are synchronized with a JetBrains
     account.
   - **Visual Studio Code** for other stuff (smaller projects, personal stuff).
     I use
     [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
     extension.
   - **NeoVIM** for quick hacks (although my configuration is prepared to handle
     more complex things).

### Awesome apps

- [seniore](https://github.com/p2kmgcl/seniore) to manage pull requests.
- [holi](https://github.com/p2kmgcl/holi) as quick notes (post-it alternative).
- [page-editor-dev-server](https://github.com/p2kmgcl/page-editor-dev-server)
  until we have something more stable.
- [mdp](https://github.com/visit1985/mdp): CLI written in Python to run text
  based presentations in terminal.
- [marp](https://marp.app/): Markdown presentation ecosystem, including editor
  extensions and PDF export.

### Programming languages

- Rust: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Deno: `curl -fsSL https://deno.land/x/install/install.sh | sh`
- NodeJS: install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
  and run
  `nvm install 16 && nvm use 16 && nvm alias default 16 && npm i -g npm yarn`
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

### Random notes

- `docker exec [CONTAINER] --it [COMMAND]`
- `mysqldump -h [HOST] -u [USER] -p[PASSWORD] [DATABASE_NAME] > dump.sql`
- `docker cp [CONTAINER]:[CONTAINER_PATH] [HOST_PATH]`
