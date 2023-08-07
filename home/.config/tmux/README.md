# tmux

## Keybindings

### Creating sessions

- `<prefix>c` New window.
- `<prefix>|` Split window vertically.
- `<prefix>-` Split window horizontally.

### Motion

- `<prefix>p` Go to previous window.
- `<prefix>n` Go to next window.
- `<prefix>0123456789` Move to the corresponding window.
- `<Ctrl>hjkl` Move to the corresponding pane.

## Moving panes

- `<prefix>!` Move current pane to a new window.
- `<prefix><space>` Switch between vertical and horizontal order.
- `<prefix>{` Swap current pane with the next pane.
- `<prefix>}` Swap current pane with the previous pane.

## Selecting text

- `<prefix>[` Enter navigation mode.
- `[NAVIGATION] hjkl` Navigate through lines.
- `[NAVIGATION] v` Start copying text in line mode.
- `[NAVIGATION] <Ctrl-v>` Start copying text in rectangle mode.
- `[NAVIGATION] y` Copy selected text and cancel.

### Miscellaneous

- `<prefix>z` Toggle focus on current pane.
- `<prefix>R` Reload configuration.
