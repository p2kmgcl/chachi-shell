# ArchLinux

For the first steps, I am going to follow the
[ArchLinux](https://wiki.archlinux.org/title/installation_guide) installation
wiki. I have tried it some years ago, and it gives an usable installation with a
minimum amount of packages installed.

**Wiki FAQ**:

- Only supports x86_64 architecture
- Uses [systemd](https://wiki.archlinux.org/title/Systemd) as service manager.
- `/bin`, `/sbin` and `/usr/sbin` are symbolic links to `/usr/bin`; `/lib` and
  `/lib64` are symbolic links to `/usr/lib`;
  [more info about filesystem hierarchy](https://man.archlinux.org/man/file-hierarchy.7).
- `pacman -Qlq package_name` gives information about an installed package.
- `systemd-boot` is used to manage a UEFI motherboard.
- `xdg-user-dirs-update.service` takes care of creating user directories like
  "downloads" or "music". This might be enabled by default by the window
  manager.
- ACPI events (power buttons, laptop lid...) can be managed with systemd.
- Firewall is not enabled by default, but iptables can be enabled and should
  work.
- By default it only supports english "standard" keyboard layout.
- `tab-completion` needs to be enabled.

## About systemd

Systemd not only manages services, but also sockets, mount points, etc. If no
extension is specified when naming a unit, it will default to `.service`. By
default it operates on system units (`--system` flag doesn't need to be
specified). `--user` can be used to manage user units.

There is a table with some common commands and how unit files work in the
[systemd arch wiki](https://wiki.archlinux.org/title/Systemd#Basic_systemctl_usage).

In order to run privileged actions (like shutdown or reboot) as an unprivileged
user, and without using sudo to spawn a whole privileged process. Polkit can be
installed and configured. Most desktop environments have authentication agents
that communicate with polkit.

With `/etc/systemd/logind.conf` ACPI events can be configured, and
`/etc/systemd/sleep.conf` to configure how system is suspended.

## Microcode updates

`amd-ucode` or `intel-ucode` package needs to be installed in order to get
microcode updates. Linux Kernel will take care of applying these updates when
they come, but it needs to be enabled in the bootloader.

In the case of systemd-boot, a `/boot/loader/entries/entry.conf` file needs to
be updated with the microcode information, for example:

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
...
```

And then ensure that the latest microcode is available in the EFI system
partition, mounted as `/boot`,

## The adventure

> - `iwctl device list`
> - `iwctl station [wlan0] scan`
> - `iwctl station [wlan0] get-networks`
> - `iwctl station [wlan0] connect [SSID]` (`/var/lib/iwd/*` is created)
> - `systemctl reboot/poweroff/suspend/hybrid-sleep`

Follow basic archlinux installation, taking into account:

- `zsh` needs to be installed (if wanted)
- `iwd` needs to be installed manually
- `[intel/amd]-ucode` might need to be installed manually
- `pacman-contrib` will help with upgrades
- [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot#Installing_the_EFI_boot_manager)
  configuration needs to be generated
- `fuse2` is needed to use AppImages

### Enable network

> - `systemctl [enable/disable/start/stop/restart] [unit]`
> - `systemctl --type=[service/target/...]`

`/etc/systemd/network/25-wireless.network`:

```
[Match]
Name=wlan0

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
```

Enable these units:

- `iwd.service`: manage wireless network
- `systemd-networkd.service`: manage network configuration
- `systemd-resolved.service`: local DNS manager

#### VPNC

> - VPN client for Cisco hardware VPNs
> - Use `vpnc --long-help`

- Install `vpnc`
- A reboot might be needed to have `/dev/net/tun` available
- Copy `/etc/vpnc/default.conf` to `/etc/vpnc/client.conf`
- Enable and start `vpnc@client` unit
- Disable if needed

### Create new user

- Install `xdg-user-dirs-update`
- `useradd -m -s /usr/bin/zsh [user]`

### Enable sudo

> `sudo -lU [user]`: checks if user can use sudo `usermod -a -G [group] [user]`:
> adds [user] to [group]

- Install `sudo`
- Creating `/etc/sudoers.d/00-sudo-group`

```
sudo ALL=(ALL) ALL
```

### Bluetooth

> - `lsmod`: list loaded kernel modules
> - `rfkill list`: checks laptop device blocking (wifi, bluetooth, etc.)

1. Install `bluez bluez-utils`
2. Check that `btusb` kernel module is loaded
3. Start/enable `bluetooth.service` unit

bluetoothctl commands:

- `power on`
- `scan on`
- `agent on`
- `devices`
- `pair [MAC]`
- `trust [MAC]`
- `connect [MAC]`

`/var/lib/bluetooth/[MAC]/[MAC]` directory is created.

To enable connecting on boot, editing `/etc/bluetooth/main.conf`:

```
[Policy]
AutoEnable=true
```

### AUR

- `pacman -S --needed base-devel` is needed
- Download files (ex. `git clone https://aur.archlinux.org/package_name.git`)
- Run `makepkg -s -i -r -c`

> Use `yay` for easier maintenance

### Sway

> - Sway is a compositor for wayland
> - `swaymsg -t get_outputs` list outputs
> - `swaymsg -t get_tree` list windows

- Install `sway swayidle swaylock clipman mako alacritty`
- Install `ulauncher` from AUR
- Theme `arc-icon-theme arc-gtk-theme ttf-ibm-plex`
- GUI apps:

  - `pcmanfm` file manager
  - `xarchiver zip unzip` file compress
  - `gimp` advanced image editor
  - `swappy` simple image editor
  - `inkscape` svg editor
  - `lxappearance` settings editor
  - `lxtask` task manager
  - `gdmap` disk space explorer
  - `smplayer` video player
  - `transmission-gtk` torrent manager

> Installing `xorg-xwayland` is necessary for better compatibility with _old_
> X11 only applications (a lot nowadays).

> `_JAVA_AWT_WM_NONREPARENTING=1` needs to be exported for some Java apps.
> [Original IntelliJ post](https://intellij-support.jetbrains.com/hc/en-us/community/posts/4402682513426/comments/4402781934354)

- `mkdir -p ~/.config/alacritty && ln -s ~/Projects/chachi-shell/config/alacritty.yml ~/.config/alacritty/alacritty.yml`
- `mkdir -p ~/.config/sway && ln -s ~/Projects/chachi-shell/config/sway.config ~/.config/sway/config`
- Run `sway`

### Audio

- Install `pipewire pipewire-alsa pipewire-pulse pipewire-jack`
- Install `helvum` and `pavucontrol` to manage audio
- Install `playerctl`

> TODO
>
> Switch on connect https://bbs.archlinux.org/viewtopic.php?id=227863

### Brightness

- Install `brightnessctl`

### Screenshot and Screen Recording

- Install `gifski grim slurp swappy wf-recorder`
- Might use `obs qt5-wayland` for advanced screen recording

#### WebRTC (experimental)

To have proper screen sharing, there is some extra work defined in
[this reddit thread](https://www.reddit.com/r/swaywm/comments/l4e55v/guide_how_to_screenshare_from_chromiumfirefox/):

- Install `xdg-desktop-portal-wlr`
- Enable `pipewire` session in all browsers (Chrome has a
  [pipewire](chrome://flags/#enable-webrtc-pipewire-capturer) feature flag)

Sway config to enable desktop-portal-wlr:

```
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
exec /usr/lib/xdg-desktop-portal-wlr
exec /usr/lib/xdg-desktop-portal --replace
```

## Maintenance

> - [Archlinux wiki maintenance documentation](https://wiki.archlinux.org/title/System_maintenance)
> - Always use `pacman -Syu` to upgrade when installing new packages

1. `archlinux-keyring` updates gpg keys storage
2. `pacman-mirrorlist` maintains an updated list of mirrors
3. Check and clear log errors:
   - `systemctl --failed`
   - `journalctl --priority 4 --reverse`
   - `journalctl --vacuum-time=2days`
4. Perform system upgrade:
   - Check [archlinux news](https://archlinux.org/news/)
   - `pacman -Qqe > ~/Projects/chachi-shell/config/pkglist.txt`
   - `checkupdates` to list updates without applying them
   - If it is safe, `pacman -Syyu`
   - If it is safe, `yay -Syyu`
   - Restart after upgrade
5. Update mirrorlist:
   - `sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.pacnew`
   - `rankmirrors -n 10 /etc/pacman.d/mirrorlist.pacnew > /etc/pacman.d/mirrorlist`
   - `mv mirrorlist.pacnew mirrorlist.backup`
6. Clean the filesystem:
   - Use `gdmap` to look for uneeded huge files
   - `paccache -rk1` remove old pacman packages (keeps last 1 version)
   - `pacman -Qtdq | pacman -Rns -` remove orphan packages
   - Manually remove old files from
     - `~/.config`
     - `~/.chache`
     - `~/.local/share`
7. Update chachi-shell repo

Missing things:

- Errors in `/var/log`?

### Fix log

#### Printing

#### Nicer network management

#### Disable "shutdown" button, or request confirmation

#### Custom keyboard fn keys

- Temporary change: `echo 2 >> /sys/module/hid_apple/parameters/fnmode`

To make it permanent, edit `/etc/modprobe.d/hid_apple.conf` and add:

```
options hid_apple fnmode=2
```

#### `virtualbox`

- Install `virtualbox`
- For linux kernel, install `virtualbox-host-modules-arch`
- `virtualbox-guest-iso` and (AUR) `virtualbox-ext-oracle` provide extra
  functionallity
- Reboot or load kernel modules manually

#### `x86/cpu: SGX disabled by BIOS`

https://techlibrary.hpe.com/docs/iss/proliant_uefi/UEFI_Edgeline_103117/GUID-5B0A4E24-26B7-46CC-8A12-5C403A14B466.html

Use this task to create a protected region of memory that is accessible only by
certain authorized functions. Enable this feature only if you have the
appropriate Intel driver on your OS. This feature is disabled by default.

The first time you use this feature, set SGX to Enabled. Even if you plan to use
Software Controlled, set SGX to Enabled until you complete the necessary steps
in the OS for the Intel drivers. Set SGX to Software Controlled after you have
configured your Intel drivers in the OS.

Procedure:

1. From the System Utilities screen, select System Configuration > BIOS/Platform
   Configuration (RBSU) > System Options > Processor Options > Intel Software
   Guard Extensions (SGX) and press Enter.
2. Select a setting and press Enter ([enabled/disabled/software controlled]).
   - Software Controlled - Enabling or disabling of SGX is determined by the
     Intel drivers, which can be configured in the OS.
   - If you select Enabled or Software Controlled, more configuration options
     are displayed:
     - Select Owner EPOCH input type
     - PRMRR Size

#### `tpm tpm0: [Firmware Bug]: TPM interrupt not working, polling instead`

https://bbs.archlinux.org/viewtopic.php?id=263004

```
lsmod | grep tpm
modinfo [tpm/tpm_crb/tpm_tis/tpm_tis_core]
```

[Blacklist modules](https://wiki.archlinux.org/title/Kernel_module#Blacklisting)
by adding some `blacklist XXX` rules to `/etc/modprobe.d`.
