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
  ];  

  home.sessionVariables = {
    OFFICE = "loffice";
  };
}
