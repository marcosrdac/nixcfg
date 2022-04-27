{ pkgs, config, nixos, ... }@args:

let
  cfg = config.gui;
in
{
  imports = [
    ./window-managers
    ./bars
    ./compositors
    ./notifiers
  ];

  options.gui.enable = with args.lib; mkOption {
      description = "Enable default gui configuration";
      type = with types; bool;
      default = true;
  };

  config = if nixos then (with args.lib; mkIf cfg.enable { # nixos
    services.xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;

      displayManager.lightdm = {
        enable = true;
        #package = pkgs.unstable.lightdm;
	#background = ""; TODO lightdm background
        #extraSeatDefaults = "";
        extraConfig = ''
          greeter-hide-users=false
        '';
      };

      desktopManager.xfce.enable = true; # TODO create module, not true by default (like below)
      #desktopManager.xfce.enable = cfg.enableXfceSession;
      ## nixos
      #enableXfceSession = mkOption {
      #  description = "Enable default host configuration";
      #  type = with types; bool;
      #  default = true;  # TODO default false?
      #};
      
      desktopManager.session = [
        {
          name = "xsession";
          start = ''
            ${pkgs.runtimeShell} $HOME/.xsession &
            waitPID=$!
          '';
        }
      ];
    };

  }) else (with pkgs.lib; {  # home-manager
    
    xsession = {
      enable = true;
      scriptPath = ".xsession";
      profileExtra = "${pkgs.feh}/bin/feh --bg-scale ${config.xdg.dataHome}/appearance/wallpaper";
      #profilePath = ".hm-profile";  # apparently does not change it
    };

  });
}
