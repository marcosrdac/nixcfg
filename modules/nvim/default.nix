{ config, pkgs, ... }:

{
  xdg.configFile = { };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = [ ];
    extraPackages = [ ];
    plugins = with pkgs.vimPlugins;
      let
        unstable = pkgs.unstable.vimPlugins;
      in [ ];
  };
}
