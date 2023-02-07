{ config, pkgs, modulesPath, ... }:

{

  host = {
    name = "daimon";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "aarch64-linux";
    nixos = "22.05";
  };

  ec2.hvm = true;
  ec2.efi = true;
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix" 
    #./hardware-configuration.nix
    #./nginx.nix
    #./nextcloud.nix
  ];

  booting = {
    enable = true;
    tmpOnTmpfs = false;
  };

  variables.enable = true;

  permissions = {
    #users = {
    #  marcosrdac = {
    #    description = "Marcos Conceição";
    #    isNormalUser = true;
    #    extraGroups = [ "nixcfg" "wheel" "docker" ];
    #  };
    #};
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
