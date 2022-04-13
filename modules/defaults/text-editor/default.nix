{ config, pkgs, ... }:

{
  imports = [
    ./neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";  # lightweight editor
    VISUAL = "nvim";  # full editor
  };

  xdg.desktopEntries = {
    text-editor = {
      name = "Text Editor";
      genericName = "Text editor";
      exec = "alacritty -e nvim %u";
      terminal = true;
      categories = [ "Application" "Office" "TextEditor" ];
    };
  };
}
