{ config, pkgs, ... }:

{

  home.username = "marcosrdac";
  home.homeDirectory = "/home/marcosrdac";
  home.stateVersion = "24.05";

  #sops = {
  #  #age.keyFile = "/home/user/.age-key.txt"; # must have no password!
  #  # It's also possible to use a ssh key, but only when it has no password:
  #  #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
  #  defaultSopsFile = ./secrets.yaml;
  #  secrets.password_1 = {
  #    # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

  #    # %r gets replaced with a runtime directory, use %% to specify a '%'
  #    # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
  #    # DARWIN_USER_TEMP_DIR) on darwin.
  #    path = "%r/test.txt"; 
  #  };
  #};


#  systemd.user.services.autorandr-main = {
#    Unit = {
#      Description = "Polybar status bar";
#      PartOf = [ "graphical-session.target" ];
#      #X-Restart-Triggers = mkIf (configFile != null) "${configFile}";
#    };
#
#    Service = {
#      #Type = "forking";
#      PassEnvironment = "DISPLAY";
#      #Environment = "PATH=${cfg.package}/bin:/run/wrappers/bin";
#      ExecStart = let
#        scriptPkg = pkgs.writeShellScriptBin "autorandr-set" ''
#          ${pkgs.autorandr}/bin/autorandr main
#          ${pkgs.feh}/bin/feh --bg-scale ${config.home.file.wallpaper.target}
#          #xsetwacom --set 'Wacom One by Wacom S Pen stylus' Rotate half
#        '';
#      in "${scriptPkg}/bin/autorandr-set";
#      #Restart = "on-failure";
#    };
#
#    Install = { WantedBy = [ "graphical-session.target" "multi-user.target" "polybar.target" ]; };
#  };

#  services.nextcloud-client = {
#    enable = true;
#    startInBackground = true;
#  };

  home.keyboard = {
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };
  #home.keyboard.layout = "br";

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  #xdg.configFile = let  # TODO pass extra configs to XDG_CONFIG_HOME
  #  mkLink = config.lib.file.mkOutOfStoreSymlink;
  #in {
  #  "GIMP" = {
  #    source = ../../config/GIMP;
  #    recursive = true;
  #  };
  #};

  #xsession.initExtra = ''
  #  ${pkgs.autorandr}/bin/autorandr mobile
  #'';

  packages = {
    #design = true;
    list = with pkgs; [
      taskwarrior
      #gnucash
      beancount
      fava
      #xournalpp
      #lua5_3
      kopia

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
      #vmware-horizon-client
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
      #tmsu    # tag based filesystem
      #zotero  # paper organization
      conda
    ];
  };

}
