{ config, pkgs, ... }:

{
  home.username = "marcosrdac";
  home.homeDirectory = "/home/marcosrdac";
  home.stateVersion = "21.05";
  home.packages = with pkgs; [ ];
  #programs.home-manager.enable = true;

  home.file."test".text = "a test";      # does not work

  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession";  # does not work

  xsession.windowManager.bspwm = {
    enable = true;
    settings = { "split_ratio" = 0.6; };
    monitors = { };
    rules = { };
    extraConfig = "";
    startupPrograms = [ "sxhkd" ];
  };

  programs.git = {
    enable = true;
    userName = "marcosrdac";
    userEmail = "marcosrdac@gmail.com";
    aliases = {
      s = "status";
    };
  };

}



    #package = pkgs.bspwm;

#  programs.zsh = {
#    enable = true;
#    shellAliases = {
#      hm = "home-manager";
#      ll = "ls -l";
#    };
#
#    history = {
#      size = 10000;
#      path = "${config.xdg.dataHome}/zsh/history";
#    };
#  };
#


#  home.file = {
#    #".vimrc".source = ./../../dotfiles/vim/vimrc;
#    ".vimrc".text = " ";
#  };

