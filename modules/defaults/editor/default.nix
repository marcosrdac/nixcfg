{ config, pkgs, ... }:

{
  imports = [
    ./neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";  # lightweight editor
    VISUAL = "nvim";  # full editor
  };
}
