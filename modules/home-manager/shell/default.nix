{ config, pkgs, ... }:

{
  imports = [
    ./starship
    ./zsh
  ];
  
  home.shellAliases = {
    # home-manager
    hm = "home-manager";
    hms = "home-manager switch --flake ${config.xdg.configHome}/nixpkgs#`hostname`-\${USER}";
    ehm = "$EDITOR ${config.xdg.configHome}/nixpkgs/home.nix";

    # making it easy
    n = "$FILEBROWSER";
    ll = "ls -l";
    lf = "$FILEBROWSER";
  };
}
