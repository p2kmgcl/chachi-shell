# `Fn` keys in custom keyboards

Although some keyboards have a shortcut to toggle _`Fn` lock_, and make `Fn`
keys act as media keys or viceversa, not all of them have this feature. I own a
Varmilo VA88M keyboard which does not have this feature, so I needed to update
this at system level.

I found this solution in the
[Archlinux wiki](https://wiki.archlinux.org/title/Apple_Keyboard). First, try
this code to make a temporary in-memory change and check if it works:

```bash
echo 2 >> /sys/module/hid_apple/parameters/fnmode
```

If it works, update `/etc/modprobe.d/hid_apple.conf` adding the following line:

```
options hid_apple fnmode=2
```
