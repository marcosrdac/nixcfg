{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ed0d2983-13a7-4141-8a93-d873a670d6df";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/98b3294e-ca23-4a72-a440-2674adadcb44";

  #fileSystems."/boot" = {
  #  device = "/dev/disk/by-uuid/ed0d2983-13a7-4141-8a93-d873a670d6df";
  #  fsType = "btrfs";
  #  options = [ "subvol=@boot" "compress=zstd" "noatime" ];
  #};

  fileSystems."/home" = { 
    device = "/dev/disk/by-uuid/ed0d2983-13a7-4141-8a93-d873a670d6df";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ed0d2983-13a7-4141-8a93-d873a670d6df";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7198-D32E";
    fsType = "vfat";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
