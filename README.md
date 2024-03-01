<h1 align="center">
  <img
    name="logo"
    src="https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/logo.png"
    alt="chachi-shell"
    style="width:100%"
  />
</h1>

The first steps I follow when installing a new system, is **cleaning up
unnecessary applications**, and also adding some essential ones:

1. Choose a **nice wallpaper**, **theme** and [**font**](/docs/fonts).
1. Configure some **browser** and **terminal emulator**.
1. Add `CHACHI_PATH` environment variable and reboot.
1. Clone this repo in `$CHACHI_PATH`
1. [Configure SSH](https://developer.1password.com/docs/ssh/get-started/).
1. Install some utils that should be included in default repositories:
   `curl fzf git nano ripgrep tmux`

## dotfiles

```bash
ln -s "$CHACHI_PATH/home/.bash_profile" "$HOME/.bash_profile" && \
ln -s "$CHACHI_PATH/home/.bashrc" "$HOME/.bashrc" && \
ln -s "$CHACHI_PATH/home/.bin" "$HOME/.bin" && \
ln -s "$CHACHI_PATH/home/.config/alacritty" "$HOME/.config/alacritty" && \
ln -s "$CHACHI_PATH/home/.config/environment.d" "$HOME/.config/environment.d" && \
ln -s "$CHACHI_PATH/home/.config/fish" "$HOME/.config/fish" && \
ln -s "$CHACHI_PATH/home/.config/hypr" "$HOME/.config/hypr" && \
ln -s "$CHACHI_PATH/home/.config/i3" "$HOME/.config/i3" && \
ln -s "$CHACHI_PATH/home/.config/lazygit" "$HOME/.config/lazygit" && \
ln -s "$CHACHI_PATH/home/.config/nvim" "$HOME/.config/nvim" && \
ln -s "$CHACHI_PATH/home/.config/rofi" "$HOME/.config/rofi" && \
ln -s "$CHACHI_PATH/home/.config/starship" "$HOME/.config/starship" && \
ln -s "$CHACHI_PATH/home/.config/sway" "$HOME/.config/sway" && \
ln -s "$CHACHI_PATH/home/.config/systemd" "$HOME/.config/systemd" && \
ln -s "$CHACHI_PATH/home/.config/tmux" "$HOME/.config/tmux" && \
ln -s "$CHACHI_PATH/home/.config/waybar" "$HOME/.config/waybar" && \
ln -s "$CHACHI_PATH/home/.editorconfig" "$HOME/.editorconfig" && \
ln -s "$CHACHI_PATH/home/.gitconfig" "$HOME/.gitconfig" && \
ln -s "$CHACHI_PATH/home/.ideavimrc" "$HOME/.ideavimrc" && \
ln -s "$CHACHI_PATH/home/.ssh" "$HOME/.ssh" && \
ln -s "$CHACHI_PATH/home/.Xdefaults" "$HOME/.Xdefaults" && \
ln -s "$CHACHI_PATH/home/.Xresources" "$HOME/.Xresources"
```

## Tools

1. [Rust](/docs/rust).
1. [lazygit](/home/.config/lazygit).
1. [Shell](/home/.config/fish).
1. [JavaScript](/docs/javascript).
1. [Seniore](/seniore).
1. [Docker](/docs/docker).
1. I use [**NeoVIM**](/home/.config/nvim), BTW.
