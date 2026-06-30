<h1 align="center">
  <img
    name="logo"
    src="https://raw.githubusercontent.com/p2kmgcl/chachi-shell/master/logo.svg"
    alt="chachi-shell"
    style="width:80%"
  />
</h1>

This repo is a dotfiles management system.

- A `docs/` directory keeps some extra notes
- `update_dotfiles.sh` symlinks everything under `home/` into `$HOME`
- `CHACHI_PATH` environment variable points to this repository
- `CHACHI_OVERRIDES_PATH` is an optional environment variable that points to a parallel repository which machine-specific files (aka "local overrides")
- `.md` files spreaded through the repo can help understand specific parts

## Initial (manual setup)

The first steps I follow when installing a new system, is **cleaning up
unnecessary applications**, and also adding some essential ones:

1. Choose a **nice wallpaper**, **theme** and [**font**](/docs/fonts)
1. Configure some **browser** and **terminal emulator**
1. Add `CHACHI_PATH` environment variable and reboot
1. Clone this repo in `$CHACHI_PATH`
1. (Optional) Add `CHACHI_OVERRIDES_PATH` environment variable and reboot
1. (Optional) Clone my overrides repo in `$CHACHI_OVERRIDES_PATH`
1. Install ssh keys
1. Install some utils that are always available: `cmake curl fzf git nano ripgrep tmux jq`
1. Run `update_dotfiles.sh`
1. Go through the following paths in order to setup my development environment:
    1. [Shell](/home/.config/shell)
    1. [Rust](/docs/rust)
    1. [JavaScript](/docs/javascript)
    1. [Docker](/docs/docker)
    1. [NeoVIM](/home/.config/nvim)

## Updating `update_dotfiles.sh`

- `lib/` is a set of utils used by `update_dotfiles.sh`
- `test.sh` runs some unit tests on these utilities
- If `update_dotfiles.sh` or any script in `lib/` needs to be updated, tests should be run and updated accordingly

## Local overrides

Any file ending in `.local` or `.local.*` is machine-specific and **never committed** (gitignored). The override system works by:

1. Placing a file at `$CHACHI_OVERRIDES_PATH/home/<path>` (e.g. `home/.config/shell/200-env.sh`)
2. `update_dotfiles.sh` symlinks it to `$HOME/<path>.local` (e.g. `~/.config/shell/200-env.local.sh`)
3. Shell config files `source` their `.local` counterpart when it exists

If you need to add machine-specific logic, use `.local` files, never edit the base files for machine-specific concerns.
