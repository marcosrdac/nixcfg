{ config, pkgs, ... }:

{
  imports = [
    ./qutebrowser
    ./firefox
    ./chrome
  ];

  home.sessionVariables = {
    BROWSER = "qutebrowser";
    ALTBROWSER = "firefox";
    ALTALTBROWSER = "brave";
  };
}
