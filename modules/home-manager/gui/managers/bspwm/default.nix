{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gui.bspwm;
in {

  options.gui.bspwm = {
    enable = mkEnableOption "Enable BSPWM (and SXHKD)";

    window = {
      gap = mkOption {
        description = "Gap between windows";
        type = with types; int;
        default = 22;
      };

      borderWidth = mkOption {
        description = "Window border width";
        type = with types; int;
        default = 3;
      };
    };

    monitors = mkOption {
        description = "Window border width";
        type = with types; attrs;
        default = {
          "eDP-1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
        };
    };
  };

  config = mkIf cfg.enable {
    home.sessionPath = [
      (builtins.toString ./bin)  # TODO ACTUALLY ADD TO PATH
    ];

    xsession.windowManager.bspwm = {
      enable = true;
      #extraConfig = pkgs.lib.fileContents ./bspwmrc;
      monitors = cfg.monitors;
      settings = {
        split_ratio = 0.6;
        borderless_monocle = true;
        single_monocle = false;
        gapless_monocle = true;
        ignore_ewmh_fullscreen = "all";
        pointer_modifier = "mod1";  # mod3

        window_gap = cfg.window.gap;
        border_width = cfg.window.borderWidth;

        external_rules_command = builtins.toString ./bin/bspwm_external_rules;
      };
      startupPrograms = [
        "[ -f ./colors ] && sh ./colors"
        #[ -x ~/.local/bin/bspwm/bspwm_display_menu ] && ~/.local/bin/bspwm/bspwm_display_menu auto
        "$TERMINAL -c dropdown_terminal -e tmux new-session -t dropdown"
        "$TERMINAL -c dropdown_calculator -e $WORKON_HOME/m/bin/python -i -c 'import numpy as np; from numpy import *'"
        "$TERMINAL -c dropdown_calculator -e julia --banner no"
        "$TERMINAL -c dropdown_mail -e neomutt"
        "$TERMINAL -c dropdown_music_player -e ncmpcpp"
      ];
    };

    xdg.configFile."bspwm/colors" = {
      #onChange = "sh ${config.xdg.configHome}/bspwm/colors";
      #onChange = "${pkgs.dash}/bin/dash ${config.xdg.configHome}/bspwm/colors";  # works
      onChange = "sh ${config.xdg.configHome}/bspwm/colors";
      text = with config.colorscheme.colors; ''
        #!/usr/bin/env sh
        bspc config focused_border_color '#${base05}'
        bspc config normal_border_color '#${base01}'
        bspc config presel_feedback_color '#${base05}'
      '';
      executable = true;
    };
    
    services.sxhkd = {
      enable = true;
      extraConfig = pkgs.lib.strings.fileContents ./sxhkdrc;
    };
  };
}
