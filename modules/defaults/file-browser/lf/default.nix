{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    lf
    ueberzug
  ];

  xdg.configFile."lf" = {
    source = ./config;
    recursive = true;
  };

  home.sessionPath = [ "${builtins.toString ./bin}" ];

  #programs.lf = {
  #  enable = true;
  #  package = pkgs.lf;
  #  settings = {
  #    commands = { };
  #    cmdKeybindings = { };
  #    keybindings = { };
  #    previewer.source = ./previewer;
  #    extraConfig = ./lfrc;
  #  };
  #};
}
