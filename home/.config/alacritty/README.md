# Alacritty

[Custom installation process](https://github.com/alacritty/alacritty/blob/master/INSTALL.md#cargo-installation).

`WAYLAND_DISPLAY=` can be added to environment to execute it in Wayland
environments (see [#97](https://github.com/alacritty/alacritty/issues/97)).
However, this variable is already set by GNOME, so I ended up moving Alacritty
binary to `/usr/bin/alacritty-bin` and creating this aliased executable as
`/usr/bin/alacritty`:

```bash
env WAYLAND_DISPLAY= /usr/bin/alacritty-bin
```
