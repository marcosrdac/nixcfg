{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "marcosrdac";  # TODO universalize
    userEmail = "mail@marcosrdac.com";  # TODO universalize
    aliases = {
      s = "status";
    };
    lfs.enable = true;
  };
}
