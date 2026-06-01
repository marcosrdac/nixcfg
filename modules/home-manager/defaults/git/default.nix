{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.userName = "marcosrdac";  # TODO universalize
    settings.userEmail = "mail@marcosrdac.com";  # TODO universalize
    settings.alias = {
      s = "status";
    };
    lfs.enable = true;
  };
}
