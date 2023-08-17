> This is a [Wayland](/docs/linux/wayland.md) based desktop environment. Check
> it’s own article for extra help and instructions.

## Needed packages

- `sway`
- `swaybg`: background image.
- `mako`: notification manager.
- `wl-clipboard`: clipboard manager.
- `brightnessctl`: control backlight.
- `polkit-gnome`: Authentication requests.
- Screen lock:
  - `swaylock`: manage lock screen.
  - `swayidle`: lock screen when idle.
- Application launcher:
  - `ulauncher`: application launcher.
    - https://github.com/Ulauncher/ulauncher-emoji
    - https://github.com/fisadev/ulauncher-better-file-browser
    - https://github.com/iboyperson/ulauncher-system
    - https://github.com/mikebarkmin/ulauncher-obsidian
    - https://github.com/KuenzelIT/ulauncher-firefox-bookmarks
    - https://github.com/safaariman/ulauncher-jira
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
  - `pasystray`: audio system tray icon.
  - Some distros need `pipewire-utils pulseaudio-utils` too.
- Bluetooth:
  - `bluez bluez-utils`: bluetooth managerment.
  - `blueman`: Bluetooth UI and system tray icon.
  - Check that `btusb` kernel module is enabled.
  - Start and enable `bluetooth.service` unit.
- Network:
  - `nmtui`: configuration CLI.
  - `nm-applet`: system tray icon.

## GUI

- `pcmanfm`: file manager.
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
