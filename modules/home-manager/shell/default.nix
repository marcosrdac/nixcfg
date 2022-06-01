{ config, pkgs, ... }:

{
  imports = [
    ./starship
    ./zsh
  ];
  
  home.shellAliases = let
    nixcfg = ''`realpath ${config.xdg.configHome}/home-manager`'';
    host = ''`hostname`'';
    user = ''$USER'';
  in {
    # home-manager
    hm = ''home-manager --flake "${nixcfg}#${host}-${user}"'';
    hms = ''home-manager switch --flake "${nixcfg}#${host}-${user}"'';
    nrs = ''sudo nixos-rebuild switch --flake "${nixcfg}#${host}"'';

    # making it easy
    n = "$FILEBROWSER";
    ll = "ls -l";
    lf = "$FILEBROWSER";
  };
}
