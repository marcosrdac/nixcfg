{ config, pkgs, ... }:

{
  home.sessionVariables = {
    TASKRC = "${config.xdg.configHome}/task/taskrc";
    TASKDATA = "${config.home.sessionVariables.XDG_DOCUMENTS_DIR}/.h/taskwarrior";
    # TODO create userdatadir default dir
  };

  home.packages = with pkgs; [
    jq
  ];

  xdg.configFile = {

    "task/taskrc" = {
      #source = ./taskrc;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.xdg.configHome}/home-manager/modules/home-manager/defaults/productivity/task/taskrc";
    };

    "task/hooks" = {
      #source = ./hooks;
      #recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.xdg.configHome}/home-manager/modules/home-manager/defaults/productivity/task/hooks";
    };
  };
}
