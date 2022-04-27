{ config, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.unstable.polybar;
    script = pkgs.lib.fileContents ./script;
    extraConfig = pkgs.lib.fileContents ./config;
  };

  home.sessionPath = [ "./bin" ];

  xdg.configFile."polybar/colors" = {
    onChange = "polybar-msg cmd restart";
    text = with config.colorscheme.colors; ''
      background     = ${base00}
      background-alt = ${base01}
      foreground-alt = ${base03}
      foreground     = ${base05}
      primary        = ${base0D}
      secondary      = ${base08}
      alert          = ${base0A}
    '';
  };
}
