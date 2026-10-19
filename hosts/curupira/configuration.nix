{ config, pkgs, modulesPath, ... }:

{
  host = {
    name = "curupira";
    zone = "America/Sao_Paulo";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "25.11";
  };

  imports = [
    ./disko.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_net"
    "virtio_scsi"
    "sd_mod"
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelParams = [ "console=ttyAMA0,115200" ];

  networking.useDHCP = false;
  networking.interfaces.enp0s6.useDHCP = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.marcosrdac = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  };

  security.sudo.wheelNeedsPassword = false;

  packages.list = with pkgs; [
    git
    vim
    curl
    wget
    htop
    btrfs-progs
  ];

  # Legacy Curupira service modules remain in the repository but are
  # intentionally not imported during the bootstrap-to-nixcfg migration.
}
