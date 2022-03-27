{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
  ];

  home.sessionVariables = {
    XIMAGEVIEWER = "sxiv";
  };
}
