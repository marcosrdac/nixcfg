{ config, pkgs, ... }:

#let
#  cfg = config.polybar;
#in
{
  #options.polybar = {
  #  enable = mkEnableOption "Enable polybar configuration";
  #};

  ##services.polybar = mkIf cfg.enable {
  #config = {
    services.polybar = {
      enable = true;
      package = pkgs.polybar;
      #script = config.lib.strings.fileContents ./script;
      extraConfig = builtins.readFile ./config;
      script = builtins.readFile ./polybar-start;
    };
  #};
}
