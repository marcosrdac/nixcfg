{ config, pkgs, ... }:

{
  host = {
    name = "bennu";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  #cloud = {
  #  dropbox = {
  #    enable = true;
  #    linkHomeDirs = true;
  #    homeSubdir = "home";
  #    linkPath = "${config.home.sessionVariables.XDG_CLOUD_HOME}/dropbox";
  #    truePath = "${config.home.sessionVariables.XDG_CLOUD_HOME}/.data/dropbox";
  #  };
  #};

  packaging.flatpak.enable = true;
}
