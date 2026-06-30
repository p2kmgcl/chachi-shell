# Shell

The goal of this directory is to provide a **shell-agnostic** configuration layer. Files here use only POSIX-compatible syntax and never assume a specific shell, so the same config works whether you're running bash, zsh, or anything else.

Two entry points load numbered files in order:

- `shell.sh` — sourced at login. Loads `NNN-*.sh` files, skipping `.interactive.` ones.
- `shellrc.sh` — sourced by interactive shells. Loads only `.interactive.` files.

## File naming

```
NNN-name[.interactive][.local].sh
```

- `NNN` controls load order
- `.interactive.` means interactive-only (prompts, aliases, completions)
- `.local.` means machine-specific (gitignored, never committed)

## Number ranges

- **100s** — session bootstrap (tmux)
- **200s** — core environment: PATH, editor, shell detection
- **430s** — Rust-based CLI tools (exa, fd, zoxide, starship, fzf)
- **460s** — JavaScript toolchain (volta, deno)
- **520s** — platform SDKs (Android)
- **900s** — shell helpers and git utilities

## Local overrides

Place a machine-specific file at `$CHACHI_OVERRIDES_PATH/home/.config/shell/NNN-name.sh` and `update_dotfiles.sh` will symlink it as `~/.config/shell/NNN-name.local.sh`. The base file sources its `.local` counterpart when it exists.
