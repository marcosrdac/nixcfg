# Bennu

My Acer Aspire A515-51G laptop configuration. TODO: redo command after installing nvidia drivers.

(Tip: yank commands then r!^r+<CR> to paste results)

```
$ nix-shell -p pkgs.inxi -p pkgs.lm_sensors --command "inxi -Fx"
---
System:    Host: fate Kernel: 6.1.13 x86_64 bits: 64 compiler: gcc v: 11.3.0 Desktop: bspwm Distro: NixOS 22.11 (Raccoon)
Machine:   Type: Desktop System: ASUS product: N/A v: N/A serial: N/A
           Mobo: ASUSTeK model: ROG CROSSHAIR X670E HERO v: Rev 1.xx serial: 221213487900222 UEFI: American Megatrends v: 1003
           date: 03/17/2023
CPU:       Info: 16-Core model: AMD Ryzen 9 7950X bits: 64 type: MT MCP arch: Zen 3 rev: 2 cache: L2: 16 MiB
           flags: avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 sse4a ssse3 svm bogomips: 287455
           Speed: 4500 MHz min/max: 3000/4500 MHz boost: enabled Core speeds (MHz): 1: 4500 2: 4500 3: 4500 4: 4500 5: 4500
           6: 4500 7: 4500 8: 4500 9: 4500 10: 4500 11: 4500 12: 4500 13: 4500 14: 4500 15: 4500 16: 4500 17: 4500 18: 4500
           19: 4500 20: 4500 21: 4500 22: 4500 23: 4500 24: 4500 25: 4500 26: 4500 27: 4500 28: 4500 29: 4293 30: 4500
           31: 4500 32: 4500
Graphics:  Device-1: NVIDIA AD102 [GeForce RTX 4090] vendor: Micro-Star MSI driver: nvidia v: 525.53 bus-ID: 01:00.0
           Device-2: Advanced Micro Devices [AMD/ATI] Raphael vendor: ASUSTeK driver: amdgpu v: kernel bus-ID: 6b:00.0
           Device-3: Microdia Webcam Vitade AF type: USB driver: snd-usb-audio,uvcvideo bus-ID: 3-3:2
           Display: server: X.org 1.20.14 driver: loaded: amdgpu note: n/a (using device driver)
           resolution: <missing: xdpyinfo>
           Message: Unable to show advanced data. Required tool glxinfo missing.
Audio:     Device-1: NVIDIA vendor: Micro-Star MSI driver: snd_hda_intel v: kernel bus-ID: 01:00.1
           Device-2: Advanced Micro Devices [AMD/ATI] Rembrandt Radeon High Definition Audio vendor: ASUSTeK
           driver: snd_hda_intel v: kernel bus-ID: 6b:00.1
           Device-3: ASUSTek USB Audio type: USB driver: hid-generic,snd-usb-audio,usbhid bus-ID: 3-11:6
           Device-4: Microdia Webcam Vitade AF type: USB driver: snd-usb-audio,uvcvideo bus-ID: 3-3:2
           Device-5: JBL Quantum 300 type: USB driver: hid-generic,snd-usb-audio,usbhid bus-ID: 3-4:3
           Device-6: C-Media Blue Snowball type: USB driver: hid-generic,snd-usb-audio,usbhid bus-ID: 5-4:4
           Sound Server-1: ALSA v: k6.1.13 running: yes
           Sound Server-2: PipeWire v: 0.3.65 running: yes
Network:   Device-1: Intel Wi-Fi 6 AX210/AX211/AX411 160MHz driver: iwlwifi v: kernel port: f000 bus-ID: 08:00.0
           IF: wlp8s0 state: up mac: f0:57:a6:9e:90:3f
           Device-2: Intel Ethernet I225-V vendor: ASUSTeK driver: igc v: kernel port: f000 bus-ID: 09:00.0
           IF: eno1 state: up speed: 100 Mbps duplex: full mac: 58:11:22:cb:c4:64
           IF-ID-1: br-3b40b9f26b1b state: down mac: 02:42:fb:de:c6:08
           IF-ID-2: br-5e67dd5e68bb state: down mac: 02:42:d0:78:ab:f5
           IF-ID-3: br-8a09e347b69c state: down mac: 02:42:b4:7f:e5:b3
           IF-ID-4: br-d6df406ef4eb state: down mac: 02:42:a8:55:3d:29
           IF-ID-5: docker0 state: down mac: 02:42:15:89:05:56
Bluetooth: Device-1: Intel AX210 Bluetooth type: USB driver: btusb v: 0.8 bus-ID: 3-6:4
           Report: hciconfig ID: hci0 rfk-id: 0 state: up address: F0:57:A6:9E:90:43
Drives:    Local Storage: total: 4.54 TiB used: 372.38 GiB (8.0%)
           ID-1: /dev/nvme0n1 vendor: Kingston model: SFYRDK2000G size: 1.82 TiB
           ID-2: /dev/sda vendor: Western Digital model: WD20EFAX-68B2RN1 size: 1.82 TiB
           ID-3: /dev/sdb vendor: Kingston model: SA400S37960G size: 894.25 GiB
           ID-4: /dev/sdc type: USB model: USB3.0 FLASH DRIVE size: 24.46 GiB
Partition: ID-1: / size: 1.7 TiB used: 365.35 GiB (21.0%) fs: btrfs dev: /dev/nvme0n1p1
           ID-2: /boot size: 486 MiB used: 202 MiB (41.6%) fs: vfat dev: /dev/nvme0n1p3
           ID-3: /home size: 1.7 TiB used: 365.35 GiB (21.0%) fs: btrfs dev: /dev/nvme0n1p1
Swap:      ID-1: swap-1 type: partition size: 119.21 GiB used: 0 KiB (0.0%) dev: /dev/nvme0n1p2
Sensors:   Message: No sensor data found. Is lm-sensors configured?
Info:      Processes: 521 Uptime: 14h 18m Memory: 124.96 GiB used: 5.34 GiB (4.3%) Init: systemd Compilers: gcc: 11.3.0
           Packages: 1907 Shell: Bash v: 5.1.16 inxi: 3.3.04
```

```
$ lsblk -f --output 'NAME,FSTYPE,FSVER,SIZE,FSUSE%,MOUNTPOINTS,LABEL,UUID'
---
NAME        FSTYPE FSVER   SIZE FSUSE% MOUNTPOINTS           LABEL UUID
sda                        1.8T
└─sda1      ntfs           1.8T                                    5FEF4B33100DFCB9
sdb                      894.3G
├─sdb1      vfat   FAT32   100M                                    F694-4487
├─sdb2                      16M
├─sdb3      ntfs         893.6G                                    58A4A9B5A4A995D2
└─sdb4      ntfs           509M                                    B43073123072DAB6
nvme0n1                    1.8T
├─nvme0n1p1 btrfs          1.7T    21% /var/lib/docker/btrfs ROOT  185d4794-4a12-4ac5-87da-98e15851ded8
│                                      /home
│                                      /nix/store
│                                      /nix
│                                      /
├─nvme0n1p2 swap   1     119.2G        [SWAP]                SWAP  85e3a4a6-4258-4f7d-a48f-413210026a3d
└─nvme0n1p3 vfat   FAT32   487M    42% /boot                 BOOT  A036-6953
```
