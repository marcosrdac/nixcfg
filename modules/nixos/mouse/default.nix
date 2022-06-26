{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.mouse;
in
{
  options.mouse = {
    enable = mkOption {
      description = "Enable default mouse configuration";
      type = with types; bool;
      default = true;
    };

    touchPad = mkOption {
      description = "Enable touch pad configuration";
      type = with types; bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.libinput.enable = cfg.touchPad;
  };
}
