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
  - `rofi`: application launcher.
  - `rofimoji`: emoji selector for `rofi`.
- Record screen:
  - `grim`: screenshot tool.
  - `slurp`: screen region selector.
  - `swappy`: simple image editor.
  - `wf-recorder`: screen video recorder.
  - `gifski`: convert video to `gif`, can be installed with:
    `cargo install gifski --features=video`
- Audio management:
  - `playerctl`: control media play.
  - `pavucontrol`: audio mixer.
  - `pasystray`: audio system tray icon.
  - Some distros need `pipewire-utils pulseaudio-utils` too.
- [[2023-07-24 Linux and Bluetooth|Bluetooth]].
- [[2023-07-24 Linux, WiFi and Internet|Network]].

## GUI

- `pcmanfm`: file manager.
- `xarchiver zip unzip`: file compress.
- `gimp`: advanced image editor.
- `inkscape`: SVG editor.
- `lxappearance`: settings editor.
- `lxtask`: task manager.
- `gdmap`: disk space explorer.
- `smplayer`: video player.
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
