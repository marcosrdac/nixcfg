{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "marcosrdac";  # TODO universalize
        email = "mail@marcosrdac.com";  # TODO universalize
      };
      alias = {
        s = "status";
      };
    };
    lfs.enable = true;
  };
}
