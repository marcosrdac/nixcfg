{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    spleen
    ttf-envy-code-r

    dejavu_fonts
    source-serif-pro

    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })

    # symbol fonts
    font-awesome_5
  ];
}
