{ config, pkgs, ... }:

{

  host = {
    name = "curupira";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.05";
  };

  imports = [
    ./oci
    ./hardware-configuration.nix
    ./nginx.nix
    ./nextcloud.nix
  ];

  booting = {
    enable = true;
    tmpOnTmpfs = false;
  };

  variables.enable = true;

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

      #imagemagick
      #ffmpeg

      # 
      #openiscsi
    ];
  };
}
