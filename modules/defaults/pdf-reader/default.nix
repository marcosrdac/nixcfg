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
}
