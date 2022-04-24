{ config, pkgs, ... }:

{
  imports = [
    ./lf
    ./thunar
  ];

  # TODO link previewer, lfrc and stuff
  # TODO this should be in common (I thought it through and it will be nice, relax)
  # also symlink lf config to $HOME/.config/lf in the user case

  home.sessionVariables = {
    FILEBROWSER = "lf";
  };
}
