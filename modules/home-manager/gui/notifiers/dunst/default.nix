{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.gui.dunst;
  dmenu = "tchoice";
  browser = "${pkgs.qutebrowser}/bin/qutebrowser";
  font = "Monospace 9";
in {
  options.gui.dunst.enable = mkEnableOption "Enable default";

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;

      configFile = "${config.xdg.configHome}/dunst/dunstrc";

      settings = with config.colorscheme.colors; {

        urgency_low = {
          background = "#${base00}";
          foreground = "#${base05}";
          timeout = 3;
        };

        urgency_normal = {
          background = "#${base00}";
          foreground = "#${base05}";
          timeout = 5;
        };

        urgency_critical = {
          background = "#${base07}";
          foreground = "#${base06}";
          timeout = 0;
        };

        global = {
          frame_color = "#${base04}";
          separator_color = "#${base01}"; # TODO separate
          monitor = 0;
          follow = "mouse";
          
          indicate_hidden = false;
          shrink = false;

          origin = "top-right";
          offset = "22x44";
          width = "(400, 400)";  # (minimum, maximum)
          height = 400;        # maximum

          notification_height = 0;
          separator_height = 5;
          padding = 10;
          horizontal_padding = 10;
          frame_width = 3;

          sort = false;

          idle_threshold = 120;  # 0 disables; when to show notification age

          font = font;
          line_height = 3;

          markup = "full";

          # The format of the message.  Possible variables are:
          #   %a  appname
          #   %s  summary
          #   %b  body
          #   %i  iconname (including its path)
          #   %I  iconname (without its path)
          #   %p  progress value if set ([  0%] to [100%]) or nothing
          #   %n  progress value if set without any extra characters
          #   %%  Literal %
          # Markup is allowed
          format = "<b>%s</b>\n%b";

          # Alignment of message text.
          # Possible values are "left", "center" and "right".
          alignment = "left";

          # Show age of message if message is older than show_age_threshold
          show_age_threshold = 60; # s; disable=-1

          word_wrap = true;
          ellipsize = "middle";  # start/middle/end
          ignore_newline = false;

          stack_duplicates = "true";
          hide_duplicate_count = "false";
          show_indicators = true;  # show (U) for url (A) for action

          ### Icons ###

          # Align icons 
          icon_position = "off";  # left/right/off
          max_icon_size = 32;  # 0 to disable

          # Paths to default icons.
          #icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";


          ### History ###

          # Should a notification popped up from history be sticky or timeout
          # as if it would normally do.
          sticky_history = true;

          # Maximum amount of notifications kept in history
          history_length = 20;


          ### Misc/Advanced ###

          dmenu = "/usr/bin/dmenu -p dunst";
          browser = browser;
          always_run_script = "true";
          class = "Dunst";
          title = "Dunst";

          startup_notification = "true";
        };

        experimental = {
          per_monitor_dpi = "false";
        };

        shortcuts = {
          close = "ctrl+Next";
          history = "ctrl+Prior";
          #context = "ctrl+shift+period";
        };

      };
    };
  };
}
