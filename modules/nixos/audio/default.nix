{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.audio;
in {
  options.audio = {
    enable = mkOption {
      description = "Whether to enable sound or not";
      type = with types; bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
