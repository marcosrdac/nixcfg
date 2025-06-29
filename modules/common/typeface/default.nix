{ config, pkgs, isNixos, ... }:

with pkgs.lib;
let
  cfg = config.typeface;
in {

  options.typeface.enable = mkEnableOption "Enable default font configuration";

  options.typeface.packages = mkOption {
    description = "Base fonts that will be installed";
    type = with types; listOf package;
    default = with pkgs; [
      corefonts
      # ubuntu-fonts
      spleen
      #ttf-envy-code-r
      #google-fonts  # not basic! (2GB) # TODO create font groups
      noto-fonts
      noto-fonts-cjk-sans
      liberation_ttf
      #fira-code
      #fira-code-symbols
      #mplus-outline-fonts
      #dina-font
      #proggyfonts
      source-sans-pro
      source-serif-pro
      noto-fonts-emoji
      recursive

      dejavu_fonts

      iosevka
      iosevka-comfy.comfy
      iosevka-comfy.comfy-duo
      iosevka-comfy.comfy-wide
      iosevka-comfy.comfy-fixed
      iosevka-comfy.comfy-motion
      fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.hack

      # symbol fonts
      font-awesome_5
    ];
  };

  options.typeface.default = {

    gui = {
      general = mkOption {
        description = "Default normal text font for the GUI";
        type = with types; str;  # not necessarily that, might be a fontType
        example = "";
        default = "";
      };

      terminal = mkOption {
        description = "Default normal text font for the terminal";
        type = with types; str;  # not necessarily that, might be a fontType
        example = "";
        default = "";
      };
    };

    # nixos-only
    tty = mkOption {
      description = "Default font for the TTY";
      type = with types; str;
      default = "Lat2-Terminus16";
      example = "";
    };
  };

  config = if isNixos then {
      fonts.packages = mkIf cfg.enable cfg.packages;
    } else {
      home.packages = mkIf cfg.enable cfg.packages;
    };

}
