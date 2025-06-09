{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.keyboard;
in
{
  options.keyboard = {
    enable = mkEnableOption "Enable default host configuration";

    gui = {
      layout = mkOption {
        description = "";
        type = with types; str;
        default = "us";
        example = "us";
      };

      variant = mkOption {
        description = "";
        type = with types; str;
        default = null;
        example = "intl";
      };

      options = mkOption {
        description = "";
        type = with types; str;
        default = "caps:swapescape";
        example = "";
      };
    };

    tty = {
      layout = mkOption {
        description = "";
        type = with types; str;
        default = "us";
        example = "de";
      };
    };

    powerKeyOff = mkEnableOption "Remove power key function";
  };

  config = mkIf cfg.enable {
    services.xserver = { 
      xkb = {
        layout = cfg.gui.layout;
        variant = cfg.gui.variant;
        options = cfg.gui.options;
      };
    };

    console.keyMap = cfg.tty.layout;

    services.logind.extraConfig = mkIf cfg.powerKeyOff ''
      HandlePowerKey=ignore
    '';

  };
}
