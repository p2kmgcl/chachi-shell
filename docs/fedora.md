# Fedora

## Replacing gnome-shell with sway

```
HOMETOWN="some-place"
WOFFU_SIGNS_FILE="/tmp/woffu-signs"
WOFFU_TOKEN="some-token"
HEADPHONES_ID="some-mac-id"
```

Packages:

- `dnf install sway swayidle swaylock alacritty ulauncher mako grim slurp swappy wf-recorder`
- `cargo install gifski`
- `dnf remove gnome-terminal`

Config files:

- `ln -s some/path.jpg ~/.background.jpg`
- `mkdir -p ~/.config/alacritty && ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.config/alacritty/alacritty.yml`
- `mkdir -p ~/.config/sway && ln -s ~/Projects/chachi-shell/config/sway.config ~/.config/sway/config`
