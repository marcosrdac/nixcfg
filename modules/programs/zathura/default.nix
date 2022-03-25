{ config, pkgs, ... }:

let
  font = "Monospace";
in
{
  programs.zathura = {
    enable = true;
    extraConfig = builtins.concatStringsSep "\n" [
      (with config.colorscheme.colors; ''
        # color config
        set default-bg "#${base00}"
        set default-fg "#${base05}"
        set statusbar-fg "#${base05}"
        set statusbar-bg "#${base00}"
        set inputbar-bg "#${base05}"
        set inputbar-fg "#${base00}"
        set notification-error-bg "#${base0B}";  # ?#
        set notification-error-fg "#${base05}"
        set notification-warning-bg "#${base0A}"
        set notification-warning-fg "#${base05}"
        set highlight-color "#${base05}"
        set highlight-active-color "#${base0A}"
        set completion-highlight-fg "#${base00}"
        set completion-highlight-bg "#${base05}"
        set completion-bg "#${base00}"
        set completion-fg "#${base05}"
        set notification-bg "#${base00}"
        set notification-fg "#${base05}"
        set recolor-lightcolor "#${base00}"
        set recolor-darkcolor "#${base05}"
        set font = font
      '')
      (pkgs.lib.strings.fileContents ./zathurarc)
    ];
  };
}


