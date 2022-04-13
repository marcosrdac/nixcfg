{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    #musicDirectory = "";
    #playlistDirectory = "";  # or path (all of these)
    #extraConfig = "";
    #dataDir = "";
    #network = {  # not needed
    #  startWhenNeeded = false;
    #  listenAddress = "";
    #  port = "";
    #};
    #dbFile = "";  # tag cache
  };

  programs.ncmpcpp = {
    enable = true;
    #mpdMusicDir = "";
    #settings = { };
    #bindings = [
    #  { key = "j"; command = "scroll_down"; }
    #  { key = "k"; command = "scroll_up"; }
    #  { key = "J"; command = [ "select_item" "scroll_down" ]; }
    #  { key = "K"; command = [ "select_item" "scroll_up" ]; }
    #];
  };
}
