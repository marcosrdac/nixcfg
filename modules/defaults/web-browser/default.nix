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

  xdg.desktopEntries = rec {
    browser = qutebrowser;
    qutebrowser = {
      name = "Qutebrowser";
      genericName = "Web Browser";
      exec = "qutebrowser %U";
      categories = [ "Application" "Network" "WebBrowser" ];
    };
    firefox = {
      name = "Firefox";
      genericName = "Web Browser";
      exec = "firefox %U";
      categories = [ "Application" "Network" "WebBrowser" ];
    };
  };
}
