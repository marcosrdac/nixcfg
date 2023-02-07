{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gui.wofi;
in {

  options.gui.wofi = {
    enable = mkEnableOption "Enable wofi";
  };

  config = mkIf cfg.enable {

    programs.rofi = {
      enable = true;
      package = x: pkgs.wofi;
      configPath = "~/.config/wofi/config";
      theme = import ./style.css.nix { inherit config pkgs; };
      location = "center";
      font = null;  # TODO make general font configuration
      cycle = false;
      #extraConfig = {
      #  run = {
      #    display-name = "$ ";
      #  };
      #};
      #plugins = [ ];
    };

  };
}
