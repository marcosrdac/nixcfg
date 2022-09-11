{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.pointer;
in
{
  options.pointer = {
    enable = mkEnableOption "Enable default mouse configuration";

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
