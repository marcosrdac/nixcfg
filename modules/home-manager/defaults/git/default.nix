{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "marcosrdac";
    userEmail = "marcosrdac@gmail.com";
    aliases = {
      s = "status";
    };
    lfs.enable = true;
  };
}
