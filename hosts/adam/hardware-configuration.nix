{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux.override {
    structuredExtraConfig = with lib.kernel; {
      CONFIG_PARPORT_1284 = yes;
    };
    ignoreConfigErrors = true;
    #argsOverride = rec {
    #  src = pkgs.fetchurl {
    #        url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    #        sha256 = "0ibayrvrnw2lw7si78vdqnr20mm1d3z0g6a0ykndvgn5vdax5x9a";
    #  };
    #  version = "4.19.60";
    #  modDirVersion = "4.19.60";
    #  };
  });

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "uas" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.kernelParams = [ ];
  boot.kernelPatches = [
    # {
    #   name = "printer-config";
    #   patch = null;
    #   extraConfig = ''
    #   	    CONFIG_PARPORT_1284 y
    #         '';
    # }
  ]; 

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/de33b3f0-0804-4f77-9aed-4e5430d86538";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/06424359-0276-4fd5-a0ea-865644d05413";
      fsType = "ext4";
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/933E-E1EA";
      fsType = "vfat";
    };

  swapDevices = [ ];

}
