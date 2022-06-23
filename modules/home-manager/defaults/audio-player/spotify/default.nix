{ config, pkgs, ... }:

{
  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
  #  "spotify"
  #  "spotify-unwrapped"
  #];
  
  home.packages = with pkgs; [
    spotify
  ];
}
