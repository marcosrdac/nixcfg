{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "marcosrdac";  # TODO universalize
    userEmail = "mail@marcosrdac.com";  # TODO universalize
    settings.alias = {
      s = "status";
    };
    lfs.enable = true;
  };
}
