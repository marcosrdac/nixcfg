{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e10df835-829e-42b3-9bbf-ba90d6271ec0";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/98278661-2178-481b-950a-2debd7266162";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/e10df835-829e-42b3-9bbf-ba90d6271ec0";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/e10df835-829e-42b3-9bbf-ba90d6271ec0";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BEC9-7588";
      fsType = "vfat";
    };

    swapDevices = [
      {
        device = "/swapfile";
        #size = 4*1024;  # idk if is useful. changed to 4G but computer still has 8G swap
      }
    ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
