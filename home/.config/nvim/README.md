- Requires tree-sitter-cli (see rust config)
- Requires installing LSP servers manually

## Nice dotfiles

- https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/

## Homebrew installation on macOS

Neovim is installed from Homebrew's `HEAD` channel:

```sh
brew install --HEAD neovim
```

Update it to the latest development version with:

```sh
brew upgrade --fetch-HEAD neovim
```

If the update fails with `would clobber existing tag`, refresh Neovim's cached
repository and retry:

```sh
neovim_brew_cache="$(brew --cache)/neovim--git"
git -C "$neovim_brew_cache" fetch --force origin
brew upgrade --fetch-HEAD neovim
```
