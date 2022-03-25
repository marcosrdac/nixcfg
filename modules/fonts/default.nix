{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    spleen
    ttf-envy-code-r
    #envypn-font
    
    dejavu_fonts
    source-serif-pro

    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];
}
