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
  };

  config = mkIf cfg.enable {
    services.xserver = { 
      layout = cfg.gui.layout;
      xkbVariant = cfg.gui.variant;
      xkbOptions = cfg.gui.options;
    };

    console.keyMap = cfg.tty.layout;
  };
}
