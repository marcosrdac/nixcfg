{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    lf

    ueberzug
    ffmpegthumbnailer
    imagemagick
    poppler
    #epub-thumbnailer
    wkhtmltopdf
    bat
    chafa
    unzip
    p7zip
    unrar
    catdoc
    #docx2txt
    odt2txt
    gnumeric
    exiftool
    #iso-info
    transmission
    mcomix3
  ];

  home.sessionPath = [ "${builtins.toString ./bin}" ];

  home.sessionVariables = {
    LF_ICONS_FILE = builtins.toString ./config/icons;
  };

  xdg.configFile."lf" = {
    source = ./config;
    recursive = true;
  };


  #programs.lf = {
  #  enable = true;
  #  package = pkgs.lf;
  #  settings = {
  #    commands = { };
  #    cmdKeybindings = { };
  #    keybindings = { };
  #    previewer.source = ./previewer;
  #    extraConfig = ./lfrc;
  #  };
  #};
}
