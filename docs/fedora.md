# Fedora

## Replacing gnome-shell with sway

```
# Used to get weather
HOMETOWN="some-place"

# Login system
WOFFU_SIGNS_FILE="/tmp/woffu-signs"
WOFFU_PRESENCE_FILE="/tmp/woffu-presence"
WOFFU_TOKEN="some-token"
WOFFU_USER_ID="some-user-id"

# Bluetooth quick connect
HEADPHONES_ID="some-mac-id"

# Using wayland
_JAVA_AWT_WM_NONREPARENTING=1
```

Packages:

- `dnf install sway swayidle swaylock alacritty rofi mako grim pipewire-utils pulseaudio-utils brightnessctl slurp swappy wf-recorder`
- `cargo install gifski --features=video` (or use binary file provided in
  github)
- `dnf remove gnome-terminal`

Config files:

- `ln -s some/path.jpg ~/.background.jpg`
- `mkdir -p ~/.config/alacritty && ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.config/alacritty/alacritty.yml`
- `mkdir -p ~/.config/sway && ln -s ~/Projects/chachi-shell/config/sway.config ~/.config/sway/config`

### Rofi
