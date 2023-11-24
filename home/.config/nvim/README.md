# NeoVIM

## Setup

1. Install `neovim`. This actually depends on the OS/distro you are using 😅.
2. Install all needed [[2023-07-03 chachi-shell|language servers]].
3. `git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1`
4. `ln -s "$CHACHI_PATH/home/.config/nvim/lua/custom" "$HOME/.config/nvim/lua/custom"`
5. Check everything is ok with `:checkhealth`
6. Install some clipboard handler for Linux (`xclip` or `wl-clipboard`).

## Keybindings

### Window management

- `[NORMAL] [Ctrl-w_s]` Split window.
- `[NORMAL] [Ctrl-w_v]` Split window vertically.
- `[NORMAL] [Ctrl-w_q]` Close a window.
- `[NORMAL] [Ctrl-w_o]` Close all but current window (same than :only).
- `[NORMAL] [Ctrl-w_T]` Move current split to a new tab.
- `[NORMAL] [Ctrl-w_=]` Resive all windows to have same size.
- `[:tab]` Create new tab.
- `[:tab *]` Outputs the given command in a new tab.
- `[NORMAL] [gt]` Move to next tab.
- `[NORMAL] [gT]` Move to previous tab.
- `[:tabclose]` Closes current tab.

### Motion

- `[NORMAL] [o]` Append a new line.
- `[NORMAL] [O]` Prepend a new line.
- `[NORMAL] [Ctrl-o]` Move to previous position.
- `[NORMAL] [Ctrl-i]` Move to next position.
- `[NORMAL] [Ctrl-u]` Move 1/2 screen up.
- `[NORMAL] [Ctrl-d]` Move 1/2 screen down.
- `[NORMAL] [gg]` Move to the beginning of the document.
- `[NORMAL] [G]` Move to the end of the document.
- `[NORMAL] [zz]` Center cursor on screen.
- `[NORMAL] []c]` Go to next change
- `[NORMAL] [[c]` Go to previous change

### Telescope

- `[Ctrl-u]` Move preview 1/2 screen up.
- `[Ctrl-d]` Move preview 1/2 screen down.
- `[Ctrl-x]` Open selection in a split.
- `[Ctrl-v]` Open selection in a vertical split.
- `[Ctrl-q]` Send all items to the quickfix list.

### Folding

- `[NORMAL] [zo]` Open fold.
- `[NORMAL] [zc]` Close fold.

### During diff split (`Gdiffsplit!`)

- `[NORMAL] [do]` Obtain/Get the corresponding chunk from other diff.
- `[NORMAL] [dp]` Put the corresponding chunk into other diff.

### Macros

- `[NORMAL] [qa]` Start recording *“a”* macro.
- `[NORMAL] [q]` Stop recording.
- `[NORMAL] [@a]` Run "a" macro.
- `[NORMAL] [@@]` Rerun last macro.

### Miscelaneous

- `[NORMAL] [K]` Show docs (run again to focus docs).
- `[VISUAL] [p]` Replaces current selection with clipboard.

## Links

- [0 to LSP Neovim RC From Scratch](https://www.youtube.com/watch?v=w7i4amO_zaE).
- [NvChad](https://nvchad.com/).
