{ config, pkgs, ... }:

{
  host = {
    name = "adam";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "21.11";
  };

  cloud = {
    dropbox = {
      enable = true;
      linkHomeDirs = true;
      homeSubdir = "home";
      linkPath = "${config.home.sessionVariables.XDG_CLOUD_HOME}/dropbox";
      truePath = "${config.home.sessionVariables.XDG_CLOUD_HOME}/.data/dropbox";
    };
  };
}
