{ config, pkgs, ... }:

{
  xsession = {

    enable = true;
    scriptPath = ".hm-xsession";
    #profilePath = ".hm-profile";
    profileExtra = "${pkgs.pywal}/bin/wal -i $HOME/tmp &";

    windowManager.bspwm = {
      enable = true;
      extraConfig = builtins.readFile ../../config/bspwm/bspwmrc;
      startupPrograms = [
        "${pkgs.sxhkd}/bin/sxhkd -c ${config.xdg.configHome}/sxhkd/sxhkdrc"
      ];
    };

  };
}
