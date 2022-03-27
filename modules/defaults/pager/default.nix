{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    less
  ];

  home.sessionVariables = {
    PAGER = "less";
  };
}
