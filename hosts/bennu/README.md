# Bennu

My Acer Aspire A515-51G laptop configuration. TODO: redo command after installing nvidia drivers.

(Tip: yank commands then r!^r+<CR> to paste results)

```
$ nix-shell -p pkgs.inxi -p pkgs.lm_sensors --command "inxi -Fx"
---
System:    Kernel 5.15.47 x86_64 bits 64 compiler gcc v 11.3.0 Console tty 2 
           Distro NixOS 22.05 (Quokka) 
Machine:   Type Laptop System Acer product Aspire A515-51G v V1.09 serial <filter> 
           Mobo KBL model Charmander_KL v V1.09 serial <filter> UEFI Insyde v 1.09 date 08/01/2017 
Battery:   ID-1 BAT1 charge 31.1 Wh (100.0%) condition 31.1/48.9 Wh (63.6%) volts 16.4 min 15.2 
           model COMPAL PABAS0241231 status Full 
CPU:       Info Dual Core model Intel Core i5-7200U bits 64 type MT MCP arch Amber/Kaby Lake 
           note check rev 9 cache L2 3 MiB 
           flags avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 ssse3 vmx bogomips 21599 
           Speed 800 MHz min/max 400/3100 MHz Core speeds (MHz) 1 800 2 800 3 800 4 800 
Graphics:  Message No device data found. 
           Device-1 Chicony HD WebCam type USB driver uvcvideo bus-ID 1-7:4 
           Display server No display server data found. Headless machine? tty 170x48 
           Message Unable to show advanced data. Required tool glxinfo missing. 
Audio:     Device-1 HDA Intel PCH driver HDA-Intel message bus/chip ids unavailable 
           Sound Server-1 ALSA v k5.15.47 running yes 
Network:   Message No device data found. 
           IF-ID-1 enp2s0f1 state up speed 100 Mbps duplex full mac <filter> 
           IF-ID-2 wlp3s0 state down mac <filter> 
Bluetooth: Device-1 N/A type USB driver btusb v 0.8 bus-ID 1-5:3 
           Report rfkill ID hci0 rfk-id 0 state down bt-service not found rfk-block hardware no 
           software no address see --recommends 
Drives:    Local Storage total 1.13 TiB used 4.69 GiB (0.4%) 
           ID-1 /dev/sda vendor Western Digital model WDS240G2G0B-00EPW0 size 223.58 GiB 
           ID-2 /dev/sdb vendor Western Digital model WD10SPZX-21Z10T0 size 931.51 GiB 
Partition: ID-1 / size 195.8 GiB used 4.66 GiB (2.4%) fs ext4 dev /dev/sda1 
           ID-2 /boot size 251 MiB used 34.7 MiB (13.8%) fs vfat dev /dev/sda4 
           ID-3 /home size 14.98 GiB used 24 KiB (0.0%) fs ext4 dev /dev/sda2 
Swap:      ID-1 swap-1 type partition size 8 GiB used 0 KiB (0.0%) dev /dev/sda3 
Sensors:   System Temperatures cpu 29.8 C mobo 27.8 C 
           Fan Speeds (RPM) N/A 
Info:      Processes 115 Uptime N/A Memory 7.65 GiB used 1.62 GiB (21.2%) Init systemd Compilers 
           gcc 11.3.0 Packages 575 Client shell wrapper v 5.1.16-release inxi 3.3.04 
```

```
$ lsblk -f
---
NAME   FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                           
├─sda1 ext4   1.0   nixos 5fae3440-f093-46c3-9f35-1d490c170cc4  180.6G     3% /nix/store
│                                                                             /
├─sda2 ext4   1.0   home  b71f1c8a-fcf8-44ca-b921-0dd493b695e9   14.2G     0% /home
├─sda3 swap   1     swap  957ad7d5-a678-41d2-9f05-296d244fa5fe                [SWAP]
└─sda4 vfat   FAT32 boot  BC99-212B                             216.3M    14% /boot
sdb                                                                           
└─sdb1 ext4   1.0   HDD   892b1061-772e-4b48-a2dc-e67cb5b7ebc7  869.2G     0% /mnt/hdd
```
