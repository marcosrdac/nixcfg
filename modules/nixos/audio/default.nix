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
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      #wireplumber.enable = true;
    };
    #hardware.pulseaudio.enable = true;
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];

  };
}
