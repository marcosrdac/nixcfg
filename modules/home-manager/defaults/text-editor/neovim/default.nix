{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
  ];

  #home.packages = let
  #  #pkgs = pkgs.neovim.override ...;
  #in [ pkgs.neovim ];

  #programs.neovim = {
    #enable = true;
    #viAlias = true;
    #vimAlias = true;
    #package = pkgs.neovim;
  #};
}
