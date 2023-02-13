{ config, pkgs, ... }:

let
  #lf-ueberzug = pkgs.writeScriptBin "lf-ueberzug" (pkgs.lib.fileContents ./bin/lf-ueberzug);
  #lf-ueberzug = pkgs.writeScriptBin "lf-u" ''
  #  #!/usr/bin/env bash
  #  set -e

  #  cleanup() {
  #    exec 3>&-
  #    rm "$FIFO_UEBERZUG"
  #  }

  #  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  #    ${pkgs.lf}/bin/lf "$@"
  #  else
  #    [ ! -d "$HOME/.cache/lf" ] && mkdir --parents "$HOME/.cache/lf"
  #    export FIFO_UEBERZUG="$HOME/.cache/lf/ueberzug-$$"
  #    mkfifo "$FIFO_UEBERZUG"
  #    #${pkgs.ueberzug}/bin/ueberzug layer -s <"$FIFO_UEBERZUG" -p json &
  #    ueberzug layer -s <"$FIFO_UEBERZUG" -p json &
  #    exec 3>"$FIFO_UEBERZUG"
  #    trap cleanup EXIT
  #    ${pkgs.lf}/bin/lf "$@" 3>&-
  #  fi
  #'';

in
{

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "unrar"
  ];

  home.packages = with pkgs; [
    lf
    #lf-ueberzug

    fzy

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
    source = ./config;  # TODO mkOutOfStorageSymlink
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
