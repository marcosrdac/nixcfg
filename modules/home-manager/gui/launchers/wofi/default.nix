#{ config, pkgs, lib, ... }:
#
#with lib;
#let
#  cfg = config.gui.wofi;
#in {
#
#  options.gui.wofi = {
#    enable = mkEnableOption "Enable wofi";
#  };
#
#  config = mkIf cfg.enable {
#
#    programs.rofi = {
#      enable = true;
#      package = x: pkgs.wofi;
#      configPath = "~/.config/wofi/config";
#      theme = import ./style.css.nix { inherit config pkgs; };
#      location = "center";
#      font = null;  # TODO make general font configuration
#      cycle = false;
#      #extraConfig = {
#      #  run = {
#      #    display-name = "$ ";
#      #  };
#      #};
#      #plugins = [ ];
#    };
#
#  };
#}

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gui.wofi;
in {
  options.gui.wofi = {
    enable = mkEnableOption "Enable wofi";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wofi ];

    xdg.configFile."wofi/config".text = ''
      show=drun
      width=600
      height=400
      prompt=Run
      allow_images=true
      insensitive=true
    '';

    xdg.configFile."wofi/style.css".text = ''
      window {
        font-family: monospace;
      }
    '';
  };
}
