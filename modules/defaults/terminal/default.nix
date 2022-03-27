{ config, pkgs, ... }:

{
  imports = [
    ./alacritty
  ];

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
