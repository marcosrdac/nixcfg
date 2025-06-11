{ config, pkgs, ... }:

{
  gui = {
    enable = true;
    #xfce.enable = true;
    bspwm.enable = true;
    polybar.enable = true;
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
    enable = true;
    design = true;
    extra = with pkgs; [
      taskwarrior

      # PETROBRAS
      networkmanager-vpnc
      singularity
      docker
      containerd
      
      scrot          # xorg screenshot  # TODO move to xorg module
      brightnessctl  # light control
      pamixer        # sound control

      julia_16-bin

      tmatrix

      keepassxc
      lxappearance
      #(callPackage (import ./packages/nvim) {})  # maybe move nvim overlay to package?
      file-roller
    ];
  };

}
