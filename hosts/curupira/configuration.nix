{ config, pkgs, ... }:

{
  imports = [
    ./oci
    ./hardware-configuration.nix
    ./nginx.nix
    ./nextcloud.nix
  ];

  host = {
    name = "curupira";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.05";
  };

  booting = {
    enable = true;
    tmpOnTmpfs = false;
  };

  permissions = {
    users = {
      marcosrdac = {
        description = "Marcos Conceição";
        isNormalUser = true;
        extraGroups = [ "nixcfg" "wheel" "docker" ];
      };
    };
  };

  packages = {
    list = with pkgs; [
      lf
      vim
      neovim
      wget
      git
      screen

      imagemagick
      ffmpeg

      # 
      #openiscsi
    ];
  };
}
