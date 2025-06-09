{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles = with pkgs.nur.repos.rycee.firefox-addons; let
      extensions = [ ublock-origin ];
    in {
      personal = {
        id = 0;
        name = "Personal";
        #settings = {
        #  "browser.startup.homepage" = "https://nixos.org";
        #  "browser.search.region" = "GB";
        #  "browser.search.isUS" = false;
        #  "distribution.searchplugins.defaultLocale" = "en-GB";
        #  "general.useragent.locale" = "en-GB";
        #  "browser.bookmarks.showMobileBookmarks" = true;
        #}

      };
      ufba = {
        id = 1;
        name = "UFBA";
      };
      ltrace = {
        id = 2;
        name = "LTrace";
      };
    };
  };
}
