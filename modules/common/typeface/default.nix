{ config, pkgs, nixos, ... }:

with pkgs.lib;
let
  cfg = config.typeface;
in {

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
      noto-fonts-cjk
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

      (pkgs.nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" ];
      })

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

  config = if nixos then {
    fonts.fonts = cfg.packages;
  } else {
    home.packages = cfg.packages;
  };

}
