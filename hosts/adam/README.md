# Adam

My portable NixOS, installed on my SSD.

```
$ nix-shell -p pkgs.inxi -p pkgs.lm_sensors --command "inxi -Fx"
---
System:    Host: adam Kernel: 5.10.88 x86_64 bits: 64 compiler: gcc v: 10.3.0 Console: tty pts/0 
           Distro: NixOS 21.05.20220115.0fd9ee1 (Okapi) 
```

```
$ lsblk -f
---
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINT
sdc                                                                           
├─sdc1 vfat   FAT32 EFI   933E-E1EA                             272.3M     0% /efi
├─sdc2 ext4   1.0   swap  d86e5e50-4f8c-4454-896b-81f8c3e21fc8   11.4G     0% /run/media/root/swap
├─sdc3 ext4   1.0   root  de33b3f0-0804-4f77-9aed-4e5430d86538  251.4G    11% /
└─sdc4 ext4   1.0   home  06424359-0276-4fd5-a0ea-865644d05413  535.2G     0% /home
```
