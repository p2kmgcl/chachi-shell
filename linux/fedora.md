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

### Custom keyboard fn keys

- Temporary change: `echo 2 >> /sys/module/hid_apple/parameters/fnmode`

To make it permanent, edit `/etc/modprobe.d/hid_apple.conf` and add:

```
options hid_apple fnmode=2
```

## Replacing sway with i3

- `dnf install i3 i3lock i3status rofi ImageMagick xrandr feh`

Config files:

- `mkdir -p ~/.i3/sway && ln -s ~/Projects/chachi-shell/config/i3.config ~/.config/i3/config`
- `ln -s ~/Projects/chachi-shell/config/xresources ~/.Xresources`
