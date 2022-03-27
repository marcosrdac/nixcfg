{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;  # symlink autoreload on v0.10
  };

  xdg.configFile = {
    "alacritty/alacritty.yml" = {
      text = pkgs.lib.strings.fileContents ./alacritty.yml;
    };
    "alacritty/colors.yml" = {
      text = import ./colors.yml.nix config.colorscheme;
    };
  };
}
