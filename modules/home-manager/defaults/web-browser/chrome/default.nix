{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    #package = pkgs.chromium;
    #package = pkgs.google-chrome;
    package = pkgs.brave;

    extensions =  [  # in URL
      { 
        # uBlock Origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      }
    ];
  };
}
