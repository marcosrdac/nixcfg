{ config, pkgs, ... }:

{
  gui = {
    enable = true;
    # X for me
    bspwm.enable = true;
    polybar.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    picom.enable = true;
    #redshift.enable = true;  # does not exist

    # X for people TODO
    #xfce.enable = true;

    # wayland
    #river.enable = true;
    #wofi.enable = true;
  };

  home.keyboard = {
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };
  #home.keyboard.layout = "br";

  typeface.enable = true;

  services.network-manager-applet.enable = true;

  #xdg.configFile = let  # TODO pass extra configs to XDG_CONFIG_HOME
  #  mkLink = config.lib.file.mkOutOfStoreSymlink;
  #in {
  #  "GIMP" = {
  #    source = ../../config/GIMP;
  #    recursive = true;
  #  };
  #};

  packages = {
    design = true;
    list = with pkgs; [
      taskwarrior
      xournalpp
      lua5_3

      # test
      #swhkd

      # mail stuff
      isync
      msmtp
      oauth2-proxy

      # rclone
      nextcloud-client
      rclone

      # PETROBRAS
      vmware-horizon-client
      #networkmanager-vpnc
      
      scrot          # xorg screenshot  # TODO move to xorg module
      brightnessctl  # light control
      pamixer        # sound control

      julia_16-bin

      tmatrix

      keepassxc
      lxappearance
      #(callPackage (import ./packages/nvim) {})  # maybe move nvim overlay to package?
      gnome.file-roller

      #nur.repos.timjrd.overlays.popcorntime
    ];
  };

}
