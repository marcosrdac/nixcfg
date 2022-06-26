{ config, pkgs, ... }:

with pkgs.lib;
let
  cfg = config.typeface;
in {
  options.typeface.enable = mkEnableOption "Enable default font configuration";

  config = {
    fonts.fontconfig.enable = cfg.enable;
  };
}
