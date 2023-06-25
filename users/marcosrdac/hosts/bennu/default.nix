{ config, pkgs, ... }:

let 
  left-monitor = "eDP-1-1";
in {
  host = {
    name = "bennu";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  #cloud = {
  #  dropbox = {
  #    enable = true;
  #    linkHomeDirs = true;
  #    homeSubdir = "home";
  #    linkPath = "${config.home.sessionVariables.XDG_CLOUD_HOME}/dropbox";
  #    truePath = "${config.home.sessionVariables.XDG_CLOUD_HOME}/.data/dropbox";
  #  };
  #};

  packaging.flatpak.enable = true;

  # screen related stuff
  gui = {
    enable = true;
    # X for me
    bspwm = {
      enable = true;
      monitors = {
        ${left-monitor} = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
      };
    };
    polybar = {
      enable = true;
      script = ''
        MONITOR=${left-monitor} ${pkgs.polybar}/bin/polybar 1 --config=${config.xdg.configHome}/polybar/config.ini &
      '';
    };
    rofi.enable = true;
    dunst.enable = true;
    picom.enable = true;
    #redshift.enable = true;  # does not exist

    # X for people TODO
    #xfce.enable = true;

    # wayland
    #river.enable = true;  # this works, just `export WLR_NO_HARDWARE_CURSORS=1`
    #wofi.enable = true;
  };

  programs.autorandr = {
    enable = true;

    profiles.main = {
      config = {
        ${left-monitor} = {
          enable = true;
          mode = "1366x768";
          position = "0x0";
          rotate = "normal";
        };
        #${right-monitor} = {
        #  enable = true;
        #  primary = true;
        #  mode = "2560x1080";
        #  #position = "2560x0";
        #  position = "2560x0";
        #  rotate = "normal";
        #};
      };
      #hooks.postswitch = builtins.readFile ./work-postswitch.sh;
      fingerprint = {
        eDP-1-1 = "00ffffffffffff0009e572060000000001190104952213780224109759548e271e5054000000010101010101010101010101010101013e1c56a0500016303020360058c21000001a000000000000000000000000000000000000000000fe00424f452043510a202020202020000000fe004e5431353657484d2d4e33320a002a";
      };
    };

    hooks = {
      postswitch = {
    #    #"notify-i3" = "''${pkgs.i3}/bin/i3-msg restart";
    #    #"change-background" = builtins.readFile ./change-background.sh;
      };
    };

  };
}
