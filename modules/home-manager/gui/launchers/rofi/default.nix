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
      enable = true;
      theme = import ./theme.rasi.nix { inherit config pkgs; };
      location = "center";
      font = null;  # TODO make general font configuration
      cycle = false;
      plugins = [ ];
    };

  };
}
