{ config, pkgs, ... }:

with pkgs.lib;
let
  cfg = config.typeface;
in {
  config = {
    fonts.fontconfig.enable = cfg.enable;
  };
}
