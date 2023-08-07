# Wayland

> Installing `xorg-xwayland` is necessary for better compatibility with _old_
> X11 only applications (a lot nowadays).

## Java applications not being refreshed

> [Original IntelliJ post](https://intellij-support.jetbrains.com/hc/en-us/community/posts/4402682513426/comments/4402781934354).

Adding this to `/etc/environment` fixes some issues with Java Applications (like
Jetbrains’ IDEs): `_JAVA_AWT_WM_NONREPARENTING=1`.

## Screen sharing

> Depending on the application (ex. Slack vs Firefox) you might not be able to
> share fullscreen, and need to share individual applications instead.

Desktop environments:

- [GNOME](/docs/linux/desktop-environments/gnome.md): install
  `xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-desktop-portal`
- [Sway](/home/.config/sway): install
  `xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-desktop-portal`

Applications:

- Firefox: add `MOZ_ENABLE_WAYLAND=1` environment variable.
- Slack: update `slack.desktop` application file adding
  `--enable-features=WebRTCPipeWireCapturer` (this should work for any
  chrome-based application).
