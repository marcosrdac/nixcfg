{ config, pkgs, nixos, ... }:

let
  fonts = with pkgs; [
    corefonts
    spleen
    ttf-envy-code-r
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    source-sans-pro
    source-serif-pro
    noto-fonts-emoji
    recursive

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
in

if nixos {
  console.font = "Lat2-Terminus16";

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Recursive Sans Casual Static Medium" ];
        sansSerif = [ "Recursive Sans Linear Static Medium" ];
        monospace = [ "Recursive Mono Linear Static" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
} else {
  fonts.fontconfig.enable = true;
  home.packages = fonts;
}

#fonts.fontconfig.localConf = ''
#  <?xml version="1.0"?>
#  <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
#  <fontconfig>
#    <alias binding="weak">
#      <family>monospace</family>
#      <prefer>
#        <family>emoji</family>
#      </prefer>
#    </alias>
#    <alias binding="weak">
#      <family>sans-serif</family>
#      <prefer>
#        <family>emoji</family>
#      </prefer>
#    </alias>
#    <alias binding="weak">
#      <family>serif</family>
#      <prefer>
#        <family>emoji</family>
#      </prefer>
#    </alias>
#  </fontconfig>
#'';  # ???
