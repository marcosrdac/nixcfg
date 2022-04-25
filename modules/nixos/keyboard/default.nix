{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.keyboard;
in
{
  options.keyboard = {
    enable = mkEnableOption "Enable default host configuration";

    xorg = {
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

    console = {
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
      layout = cfg.xorg.layout;
      xkbVariant = cfg.xorg.variant;
      xkbOptions = cfg.xorg.options;
    };

    console.keyMap = cfg.console.layout;
  };
}
