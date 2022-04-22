{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice-still
    texlive.combined.scheme-full
    pandoc
    unstable.xpdf  #=: pdftotext, pdfimages - tagged insecure (?)
    imagemagick
    inkscape gimp
    unstable.write_stylus
    aegisub
  ];  

  home.sessionVariables = {
    OFFICE = "loffice";
  };

  xdg.desktopEntries = rec {
    vector-image-editor = {
      name = "Vector image editor";
      genericName = "Vector image editor";
      exec = "inkscape %u";
      categories = [ "Application" "Graphics" "VectorGraphics" ];
    };
    handwritten-editor = {
      name = "Handwritten editor";
      genericName = "Handwritten editor";
      exec = "Write %u";
      categories = [ "Application" "Office" "VectorGraphics" ];
    };
    office-suite = {
      name = "Office suite";
      genericName = "Office suite";
      exec = "libreoffice %u";
      categories = [ "Application" "Office" ];
    };
  };
}
