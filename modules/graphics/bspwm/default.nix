{ config, pkgs, ... }:

{
  home.sessionPath = [
    (builtins.toString ./bin)
  ];

  xsession.windowManager.bspwm = {
    enable = true;
    extraConfig = pkgs.lib.strings.fileContents ./bspwmrc;
    startupPrograms = [ ];
  };
  
  services.sxhkd = {
    enable = true;
    extraConfig = pkgs.lib.strings.fileContents ./sxhkdrc;
  };
}
