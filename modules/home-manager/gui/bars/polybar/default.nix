{ config, pkgs, ... }:

with pkgs.lib;
let
  cfg = config.gui.polybar;
in {

  options.gui.polybar = {
    enable = mkEnableOption "Enable default polybar configuration";

    script = mkOption {
      description = "Polybar startup script";
      type = with types; str;
      default = "";
      example = literalString ''MONITOR=eDP-1 ${pkgs.polybar}/bin/polybar 1 --config=${config.xdg.configHome}/polybar/config.ini'';
    };

    font = {
      regular = mkOption {
        description = "Font";
        type = with types; str;
        default = "spleen:size=20";
        example = "monospace";
      }; 
      symbols = mkOption {
        description = "Symbol font";
        type = with types; str;
        default = "Font Awesome 5 Free Solid:size=14";
        example = "monospace";
      };
    };

    bar = {
      height = mkOption {
        description = "Bar height in pixels";
        type = with types; str;
        default = "22";
      };
      width = mkOption {
        description = "Bar width in pixels";
        type = with types; str;
        default = "100%";
      };
    };
  };


  config = {
    services.polybar = mkIf cfg.enable {
      enable = true;
      package = pkgs.polybarFull;
      script = cfg.script;
      extraConfig = fileContents ./modules.ini;

      settings = {
        "colors" = with config.colorScheme.palette; {
          background = "${base00}";
          background-alt = "${base01}";
          foreground-alt = "${base03}";
          foreground = "${base05}";
          primary = "${base0D}";
          secondary = "${base08}";
          alert = "${base0A}";
        };

        "bar/base" = {
          monitor = "\${env:MONITOR:}";

          # controling bar from the  outside
          enable-ipc = true;

          # geometry
          #dpi = "\${xrdb:dpi : 100}";
          width               = cfg.bar.width;
          height              = cfg.bar.height;
          padding-left        = 0;
          padding-right       = 0;
          module-margin-left  = 1;
          module-margin-right = 1;
          fixed-center        = true;
          # style
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
          font-0 = cfg.font.regular;
          font-1 = cfg.font.symbols;
          # window manager
          wm-restack = "bspwm";
          # cursors
          cursor-click  = "default";
          cursor-scroll = "default";
        };

        "bar/1" = {
          "inherit" = "bar/base";
          # modules position
          modules-left   = "bspwm xkeyboard";
          modules-center = "mpd";
          modules-right  = "wlan eth pulseaudio brightness battery date time";
          #modules-right  = remainder recording wlan eth pulseaudio brightness battery timer date time
          # tray position
          tray-position   = "left";
          tray-padding    = 2;
          tray-background = "\${colors.background}";
        };

        "bar/21" = {
          "inherit" = "bar/base";
          # modules position
          modules-left   = "bspwm xkeyboard";
          modules-center = "mpd";
          modules-right  = "wlan eth pulseaudio brightness battery date time";
          #modules-right  = remainder recording wlan eth pulseaudio brightness battery timer date time
          # tray position
          tray-position   = "left";
          tray-padding    = 2;
          tray-background = "\${colors.background}";
        };

        "bar/22" = {
          "inherit" = "bar/base";
          # modules position
          modules-left   = "bspwm";
          modules-center = "";
          modules-right  = "wlan eth pulseaudio brightness battery date time";
        };

        "settings" = {
          screenchange-reload = true;
        };

        "global/wm" = {
          "margin-top" = 0;
          "margin-bottom" = 0;
        };

      };

    };

    home.sessionPath = mkIf cfg.enable [ "./bin" ];

    # ATTEMPTS TO MAKE POLYBAR START AFTER BSPWM WITH NO SUCCESS BELLOW
    # - polybar does not find bspwm socket at tmp for race condition and only does when restarted

    #systemd.user.services.polybar.Unit.After = [ "hm-graphical-session.target" ];
    #systemd.user.services.polybar.Unit.After = [ "graphical-session.target" ];
    #systemd.user.services.polybar.Unit.PartOf = pkgs.lib.mkForce [ ];
    #systemd.user.services.polybar.Service.ExecStart = let
    #  scriptPkg = pkgs.writeShellScriptBin "polybar-start" ''
    #    #while [ ! -e /tmp/bspwm_0_0-socket ]; do
    #    #  sleep 1  # Wait for 1 second before checking again
    #    #done
    #    ${cfg.script}
    #  '';
    #in pkgs.lib.mkForce "${scriptPkg}/bin/polybar-start";

    #systemd.user.services.polybar.enable = pkgs.lib.mkForce false;
    #systemd.user.services.polybar.Unit.After = [ "graphical-session.target" "tray.target" ];
    #systemd.user.services.polybar.Unit.PartOf = [ "graphical-session.target" "tray.target" ];
    #systemd.user.services.polybar.Install.WantedBy = [ "graphical-session.target" "tray.target" ];

  };

}
