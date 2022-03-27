{ config, pkgs, ... }:

{
  imports = [
    ./lf
    ./thunar
  ];

  # TODO link previewer, lfrc and stuff

  home.sessionVariables = {
    #FILEBROWSER = "lf";
    FILEBROWSER = "${lf/bin/lf-ueberzug}";
  };
}
