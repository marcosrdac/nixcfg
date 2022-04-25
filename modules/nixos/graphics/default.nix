{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.graphics;
in
{
  options.graphics = {
    enable = mkEnableOption "Enable default host configuration";

    # TODO default false?
    enableXfceSession = mkOption {
      description = "Enable default host configuration";
      default = true;
      type = with types; bool;
    };
    # TODO lightdm background
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;

      displayManager.lightdm = {
        enable = true;
        #package = pkgs.unstable.lightdm;
	#background = "";
        #extraSeatDefaults = "";
        extraConfig = ''
          greeter-hide-users=false
        '';
      };

      desktopManager.xfce.enable = cfg.enableXfceSession;
      
      desktopManager.session = [
        {
          name = "xsession";
          start = ''
            ${pkgs.runtimeShell} $HOME/.xsession &
            waitPID=$!
          '';
        }
      ];
  
      libinput.enable = true;
    };
  };
}
