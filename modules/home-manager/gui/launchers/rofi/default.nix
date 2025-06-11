{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gui.rofi;
in {

  options.gui.rofi = {
    enable = mkEnableOption "Enable rofi";
  };

  config = mkIf cfg.enable {

    programs.rofi = {
      package = pkgs.rofi;
      enable = true;
      theme = import ./style.css.nix { inherit config pkgs; };
      location = "center";
      font = null;  # TODO make general font configuration
      cycle = false;
      #extraConfig = {
      #  run = {
      #    display-name = "$ ";
      #  };
      #};
      plugins = [ ];
    };

  };
}
