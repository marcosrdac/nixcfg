{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
  ];

  home.sessionVariables = {
    XIMAGEVIEWER = "sxiv";
  };

  xdg.desktopEntries = {
    image-viewer = {
      name = "Image viewer";
      genericName = "Image viewer";
      exec = "sxiv -qba %u";
      terminal = true;
      categories = [ "Application" "Graphics" "Viewer" ];
    };
  };
}
