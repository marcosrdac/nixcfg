{ config, pkgs, ... }:

with pkgs.lib;
let
  cfg = config.gui.polybar;
in {

  options.gui.polybar = {
    enable = mkEnableOption "Enable default polybar configuration";
  };

  config = {
    services.polybar = mkIf cfg.enable {
      enable = true;
      package = pkgs.unstable.polybar;
      script = fileContents ./script;
      extraConfig = fileContents ./config;
    };

    home.sessionPath = mkIf cfg.enable [ "./bin" ];  # TODO make it like the common/packages modules

    xdg.configFile."polybar/colors" = mkIf cfg.enable {
      #onChange = "polybar-msg cmd restart";
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
  };

}
