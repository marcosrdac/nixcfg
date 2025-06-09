{ config, pkgs, ... }:

let 
  monitors = {
    left = {
      name = "eDP-1";
      mode = "1920x1080";
      dpi = 96;
      position = "0x0";
      rotate = "normal";
      fingerprint = "00ffffffffffff0006af91da00000000111e0104a51f117803b815a6544a9b260e505400000001010101010101010101010101010101143780b87038244010103e0035ae10000018102c80b87038244010103e0035ae10000018000000fe0041554f0a202020202020202020000000fe004231343048414e30362e32200a0044";
      primary = true;
    };
  };
in {

  host = {
    name = "goryo";
    zone = "Brazil/East";
    locale = "en_US.UTF-8";
    system = "x86_64-linux";
    nixos = "22.05";
  };

  #wayland.windowManager.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  config = rec {
  #    startup = [
  #      {command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
  #      {command = "firefox"; }
  #    ];
  #    modifier = "Mod4";
  #    terminal = "alacritty"; 
  #    #keybindings = {
  #    #  "Mod4+Space" = "exec alacritty";
  #    #  "Mod4+Return" = "exec alacritty";
  #    #};
  #  };
  #};

  #packaging.flatpak.enable = true;

  typeface.enable = true;

  appearance.redshift.enable = true;

  gui = {
    enable = true;
    # X for me
    bspwm = {
      enable = true;
      monitors = {
        ${monitors.left.name} = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
      };
      startupPrograms = [ 
           "(sleep 2 && ${pkgs.numlockx}/bin/numlockx off)"
      ]
        ++ pkgs.lib.optionals config.gui.polybar.enable [
           "${pkgs.autorandr}/bin/autorandr mobile"
           #nix-shell -p xorg.xdpyinfo --command 'xdpyinfo | grep resolution'
          #''MONITOR=${monitors.left.name} DPI=${monitors.left.dpi} ${pkgs.polybar}/bin/polybar 1 --config=${config.xdg.configHome}/polybar/config.ini''
        ];
    };
    polybar = {
      enable = true;
      bar.height = "30";
      font.regular = "spleen:size=20";
      font.symbols = "Font Awesome 5 Free Solid:size=14";
      #script = ''
        #MONITOR=${monitors.left.name} DPI=${toString monitors.left.dpi} ${pkgs.polybar}/bin/polybar 1 --config=${config.xdg.configHome}/polybar/config.ini &
      #'';
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

  #systemd.user.services.autorandr = {
  #  Unit.Description = "AutoRandR Configuration";
  #  #Install.WantedBy = [ "default.target" ];
  #  #Unit.After = [ "hm-graphical-session.target" ];
  #  Unit.Requires = [ "graphical-session.target" ];
  #  Service = {
  #    Type = "oneshot";
  #    ExecStart = "${pkgs.autorandr}/bin/autorandr mobile";
  #  };
  #};

  programs.autorandr = {
    enable = true;

    profiles.mobile = {
      fingerprint = {
        ${monitors.left.name} = monitors.left.fingerprint;
      };
      config = {
        ${monitors.left.name} = {
          enable = true;
          mode = monitors.left.mode;
          dpi = monitors.left.dpi;
          position = monitors.left.position;
          rotate = monitors.left.rotate;
          primary = monitors.left.primary;
        };
      };
      hooks.postswitch = ''
        pkill polybar
        MONITOR=${monitors.left.name} DPI=${toString monitors.left.dpi} ${pkgs.polybar}/bin/polybar 1 --config=${config.xdg.configHome}/polybar/config.ini &
      '';
    };

    hooks = {
      postswitch = {
    #    #"notify-i3" = "''${pkgs.i3}/bin/i3-msg restart";
    #    #"change-background" = builtins.readFile ./change-background.sh;
      };
    };

  };

  packages = {
    design = true;
    list = with pkgs; [
      stremio
    ];
  };
}
