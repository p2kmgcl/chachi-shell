# Development environment

## Setup

1. Install `openssh`.
2. Add a new SSH key.
3. Install: `curl fzf git jq nano ripgrep tree`
4. Install [Autojump](https://github.com/wting/autojump#name).
5. Clone this project in `~/Projects/chachi-shell`
6. `ln -s ~/Projects/chachi-shell/config/editorconfig ~/.editorconfig`
7. `ln -s ~/Projects/chachi-shell/config/gitconfig ~/.gitconfig`

### Awesome apps

- [seniore](https://github.com/p2kmgcl/seniore) to manage pull requests.
- [holi](https://github.com/p2kmgcl/holi) as quick notes (post-it alternative).
- [mdp](https://github.com/visit1985/mdp): CLI written in Python to run text
  based presentations in terminal.
- [marp](https://marp.app/): Markdown presentation ecosystem, including editor
  extensions and PDF export.

### Programming languages

#### Rust

- Binary `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Language Server: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary

#### Others

- Deno: `curl -fsSL https://deno.land/x/install/install.sh | sh`
- NodeJS: install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
  and run
  `nvm install 16 && nvm use 16 && nvm alias default 16 && npm i -g npm yarn`
- Python

### Tmux

1. Install `tmux`
2. `ln -s ~/Projects/chachi-shell/config/tmux.conf ~/.tmux.conf`

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

1. Install `neovim`.
2. `ln -s ~/Projects/chachi-shell/dev-env/neovim ~/.config/nvim`
3. Check everything is ok with `:checkhealth`
4. Install some clipboard handler for linux (`xclip` or `wl-clipboard`)

### Random notes

- `docker exec [CONTAINER] --it [COMMAND]`
- `mysqldump -h [HOST] -u [USER] -p[PASSWORD] [DATABASE_NAME] > dump.sql`
- `docker cp [CONTAINER]:[CONTAINER_PATH] [HOST_PATH]`
