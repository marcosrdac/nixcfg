{ config, pkgs, modulesPath, ... }:

{

  host = {
    name = "elf";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  ec2.hvm = true;
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix" 
    ./nginx
    #./nextcloud
  ];

  booting = {
    enable = true;
    tmpOnTmpfs = false;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 20 ];
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

      #imagemagick
      #ffmpeg
    ];
  };

}
