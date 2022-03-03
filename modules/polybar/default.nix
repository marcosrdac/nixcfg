{ config, pkgs, ... }:

{
  services.polybar = {
    enable = true;

    package = pkgs.unstable.polybar;

    script = ''
      MONITOR=$(polybar --list-monitors | cut -d":" -f1) polybar --reload example &
    '';

    config = {

      "colors" = {
        #foreground = "#ffffff";
        #foreground-alt = "#aaaaaa";
        #background = "#000000";
        #background-alt = "#555555";
        #primary = "#00ff00";
        #secondary = "#ff0000";
        #alert = "#ffff00";
        #disabled = "#555555";

        foreground = "\${xrdb:color15 : #ffffff}";
        foreground-alt = "\${xrdb:color7 : #aaaaaa}";
        background = "\${xrdb:color0 : #000000}";
        background-alt = "\${xrdb:color8 : #555555}";
        primary = "\${xrdb:color2 : #00ff00}";
        secondary = "\${xrdb:color1 : #ff0000}";
        alert = "\${xrdb:color3 : #ffff00}";
        #disabled = "#707880";
        disabled = "\${xrdb:color8 : #555555}";
      };
      
      "bar/example" = {
        width = "100%";
        height = "24pt";
        radius = "6";
        
        # dpi = 96
        
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        
        line-size = "3pt";
        
        border-size = "4pt";
        border-color = "#00000000";
        
        padding-left = "0";
        padding-right = "1";
        
        module-margin = "1";
        
        separator = "|";
        separator-foreground = "\${colors.disabled}";
        
        font-0 = "monospace;2";
        
        modules-left = "xworkspaces xwindow";
        modules-right = "filesystem pulseaudio xkeyboard memory cpu wlan eth date";
        
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        
        enable-ipc = "true";
        
        # tray-position = right
        
        # wm-restack = generic
        # wm-restack = bspwm
        # wm-restack = i3
        
        # override-redirect = true
      };
      
      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        
        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline= "\${colors.primary}";
        label-active-padding = "1";
        
        label-occupied = "%name%";
        label-occupied-padding = "1";
        
        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = "1";
        
        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = "1";
      };
      
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
      
      "module/filesystem" = {
        type = "internal/fs";
        interval = "25";
        mount-0 = "/";
        label-mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.disabled}";
      };
      
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume-prefix = ''"VOL "'';
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };
      
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";
        label-layout = "%layout%";
        label-layout-foreground = "\${colors.primary}";
        label-indicator-padding = "2";
        label-indicator-margin = "1";
        label-indicator-foreground = "\${colors.background}";
        label-indicator-background = "\${colors.secondary}";
      };
      
      "module/memory" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = ''"RAM "'';
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage_used:2%%";
      };
      
      "module/cpu" = {
        type = "internal/cpu";
        interval = "2";
        format-prefix = ''"CPU "'';
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage:2%%";
      };
      
      "network-base" = {
        type = "internal/network";
        interval = "5";
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        label-disconnected = "%{F#F0C674}%ifname%%{F#707880} disconnected";
      };
      
      "module/wlan" = {
        "inherit" = "network-base";
        interface-type = "wireless";
        label-connected = "%{F#F0C674}%ifname%%{F-} %essid% %local_ip%";
      };
      
      "module/eth" = {
        "inherit" = "network-base";
        interface-type = "wired";
        label-connected = "%{F#F0C674}%ifname%%{F-} %local_ip%";
      };
      
      "module/date" = {
        type = "internal/date";
        interval = "1";
        date = "%H:%M";
        date-alt = "%Y-%m-%d %H:%M:%S";
        label = "%date%";
        label-foreground = "\${colors.primary}";
      };
      
      "settings" = {
        screenchange-reload = "true";
        pseudo-transparency = "true";
      };

    };
  };
}
