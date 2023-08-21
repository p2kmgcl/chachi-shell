# Microcode updates

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
partition, mounted as `/boot`.
