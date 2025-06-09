{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.audio;
in {
  options.audio = {
    enable = mkEnableOption "Whether to enable sound or not";
  };

  config = mkIf cfg.enable {
    #sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      #wireplumber.enable = true;
    };
    services.pulseaudio.enable = false;
    services.pulseaudio.package = pkgs.pulseaudioFull;
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];

  };
}
