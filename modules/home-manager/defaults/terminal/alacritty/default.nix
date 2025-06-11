{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
  };

  xdg.configFile = {
    "alacritty/alacritty.toml" = {
      text = pkgs.lib.strings.fileContents ./alacritty.toml;
    };
    "alacritty/colors.toml" = {
      text = import ./colors.toml.nix config.colorScheme;
    };
  };
}
