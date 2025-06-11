{ config, pkgs, isNixos, ... }:

with pkgs.lib;
let
  cfg = config.typeface;
in {

  #options.typeface.enable = mkEnableOption "Enable default font configuration";

#  config = mkIf cfg.enable {
#    console.font = cfg.console;
#
#    fonts = {
#      fontDir.enable = true;
#      enableDefaultFonts = true;
#      fontconfig = {
#        defaultFonts = {
#          serif = [ "Recursive Sans Casual Static Medium" ];
#          sansSerif = [ "Recursive Sans Linear Static Medium" ];
#          monospace = [ "Recursive Mono Linear Static" ];
#          emoji = [ "Noto Color Emoji" ];
#          #localConf = ''
#          #  <?xml version="1.0"?>
#          #  <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
#          #  <fontconfig>
#          #    <alias binding="weak">
#          #      <family>monospace</family>
#          #      <prefer>
#          #        <family>emoji</family>
#          #      </prefer>
#          #    </alias>
#          #    <alias binding="weak">
#          #      <family>sans-serif</family>
#          #      <prefer>
#          #        <family>emoji</family>
#          #      </prefer>
#          #    </alias>
#          #    <alias binding="weak">
#          #      <family>serif</family>
#          #      <prefer>
#          #        <family>emoji</family>
#          #      </prefer>
#          #    </alias>
#          #  </fontconfig>
#          #'';
#        };
#      };
#    };
#  };
}
