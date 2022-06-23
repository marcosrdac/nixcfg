{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "bennu";
  time.timeZone = "Brazil/East";

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  environment.systemPackages = with pkgs; [ wget curl git ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  networking.networkmanager.enable = true;

  system.copySystemConfiguration = true;
  system.stateVersion = "22.05"; # Did you read the comment?
}

