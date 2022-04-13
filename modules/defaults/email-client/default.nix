{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
  ];

  home.sessionVariables = {
    XIMAGEVIEWER = "sxiv";
  };

  xdg.desktopEntries = rec {
    email-client = {
      name = "E-mail client";
      genericName = "E-mail client";
      # TODO needs to be terminal specific?
      exec = "alacritty -e neomutt %u";
      terminal = true;
      categories = [ "Application" "Network" "Email" ];
    };
  };
}
