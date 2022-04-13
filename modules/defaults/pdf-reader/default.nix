{ config, pkgs, ... }:

{
  imports = [
    ./zathura
    ./evince
  ];

  home.sessionVariables = {
    PDFREADER = "zathura";
    ALTPDFREADER = "evince";
  };

  xdg.desktopEntries = rec {
    pdf-reader = {
      name = "PDF reader";
      genericName = "PDF reader";
      exec = "zathura %u";
      categories = [ "Application" "Office" "Viewer" ];
    };
  };
}
