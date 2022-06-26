{ config, pkgs, ... }:

{
  imports = [
    ./alacritty
  ];

  home.sessionVariables = {
    TERMINAL = "alacritty";
    #TERMINAL = "xterm";
  };

  xdg.desktopEntries = rec {
    terminal-emulator = {
      name = "Terminal emulator";
      genericName = "Terminal emulator";
      exec = "alacritty -e %u";
      categories = [ "Application" "System" "TerminalEmulator" ];
    };
    TerminalEmulator = terminal-emulator;
  };
}
