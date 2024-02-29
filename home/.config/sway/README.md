# sway

> This is a [Wayland](/docs/linux/wayland.md) based desktop environment. Check
> it’s own article for extra help and instructions.

[Useful sway addons](https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway).

## Needed packages

- `sway`
- `swaybg`: background image.
- `mako`: notification manager.
- `wl-clipboard`: clipboard manager.
- `brightnessctl`: control backlight.
- `polkit-gnome`: Authentication requests.
- `xdg-desktop-portal-wlr`: Wayland desktop portal.
- `xwayland`: support for X11 applications.
- Screen lock:
  - `swaylock`: manage lock screen.
  - `swayidle`: lock screen when idle.
- Application launcher:
  - `ulauncher`: application launcher.
    - [Emoji selector](https://github.com/Ulauncher/ulauncher-emoji).
    - [File browser](https://github.com/fisadev/ulauncher-better-file-browser).
    - [Power off, restart, etc.](https://github.com/iboyperson/ulauncher-system)
- Record screen:
  - `grim`: screenshot tool.
  - `slurp`: screen region selector.
  - `swappy`: simple image editor.
  - `wf-recorder`: screen video recorder.
  - `gifski`: convert video to `gif`, can be installed with:
    `cargo install gifski --features=video`
    > If it is installed with cargo, add a symlink to `/usr/bin/gifski`, so it
    > is available for recording scripts.
- Audio management:
  - `playerctl`: control media play.
  - `pavucontrol`: audio mixer.
  - Some distros need `pipewire-utils pulseaudio-utils` too.
- Bluetooth:
  - `bluez bluez-utils`: bluetooth management.
  - `blueman`: Bluetooth UI and system tray icon.
  - Check that `btusb` kernel module is enabled.
  - Start and enable `bluetooth.service` unit.
- Network:
  - `nmtui` (also found as `NetworkManager-tui`): configuration CLI.
  - `nm-applet` (also found as `network-manager-applet`): system tray icon.

## GUI

- `thunar thunar-archive-plugin`: file manager.
- `xarchiver zip unzip`: file compress.
- `gimp`: advanced image editor.
- `inkscape`: SVG editor.
- `lxappearance`: settings editor.
- `lxtask`: task manager.
- `gdmap`: disk space explorer.
- `clapper`: video player.
- `transmission-gtk`: torrent manager.

## Configuration files

- [Terminal](https://github.com/search?q=repo%3Ap2kmgcl%2Fchachi-shell+path%3Asway+%22set+%24term%22&type=code).
- [Browser](https://github.com/search?q=repo%3Ap2kmgcl%2Fchachi-shell+path%3Asway+%22set+%24browser%22&type=code).
- [Font](https://github.com/search?q=repo%3Ap2kmgcl%2Fchachi-shell+path%3Asway+%22font+pango%22&type=code).
- [GUI Theme](https://github.com/search?q=repo%3Ap2kmgcl%2Fchachi-shell+path%3Asway+gtk-theme&type=code).
- `ln -s some/path.jpg ~/.background.jpg`

## Screen configuration

- `swaymsg -t get_outputs` list outputs.
- `swaymsg -t get_tree` list windows.
- `swaymsg output HDMI-A-1 pos 0 0 res 2560 1440 scale 1.5` update output.
