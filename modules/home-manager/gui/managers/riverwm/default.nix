{ config, pkgs, ... }:

{
#  home.packages = with pkgs; [
#    unstable.river
#    slurp grim
#    waybar
#  ];
#
#  #xsession.windowManager.command = "river";
#
#  xdg.configFile = {
#    "river/init" = {
#      source = ./init;
#      executable = true;
#    };
#    "river/bar" = {
#      source = ./bar;
#      executable = true;
#    };
#  };
#
#  #home.sessionPath = [
#  #  (builtins.toString ./bin)
#  #];
}
