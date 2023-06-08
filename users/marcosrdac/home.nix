{ config, pkgs, ... }:

let
  left-monitor = "HDMI-A-1-1";
  right-monitor = "DP-1";
in {

  home.username = "marcosrdac";
  home.homeDirectory = "/home/marcosrdac";
  home.stateVersion = "22.05";

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


  systemd.user.services.autorandr-main = {
    Unit = {
      Description = "Polybar status bar";
      PartOf = [ "graphical-session.target" ];
      #X-Restart-Triggers = mkIf (configFile != null) "${configFile}";
    };

    Service = {
      #Type = "forking";
      PassEnvironment = "DISPLAY";
      #Environment = "PATH=${cfg.package}/bin:/run/wrappers/bin";
      ExecStart = let
        scriptPkg = pkgs.writeShellScriptBin "autorandr-set" ''
          ${pkgs.autorandr}/bin/autorandr main
          ${pkgs.feh}/bin/feh --bg-scale ${config.home.file.wallpaper.target}
          #xsetwacom --set 'Wacom One by Wacom S Pen stylus' Rotate half
        '';
      in "${scriptPkg}/bin/autorandr-set";
      #Restart = "on-failure";
    };

    Install = { WantedBy = [ "graphical-session.target" "multi-user.target" "polybar.target" ]; };
  };

  programs.autorandr = {
    enable = true;

    profiles.main = {
      config = {
        ${right-monitor} = {
          enable = true;
          primary = true;
          mode = "2560x1080";
          #position = "2560x0";
          position = "2560x0";
          rotate = "normal";
        };
        #HDMI-0 = {
          #enable = true;
          #primary = true;
          #mode = "2560x1080";
          ##position = "2560x0";
          #position = "2560x0";
          #rotate = "normal";
        #};
        #HDMI-A-1-1 = {
          #enable = true;
          #mode = "2560x1080";
          #position = "0x0";
          #rotate = "normal";
        #};
        ${left-monitor} = {
          enable = true;
          mode = "2560x1080";
          position = "0x0";
          rotate = "normal";
        };
      };
      #hooks.postswitch = builtins.readFile ./work-postswitch.sh;
      fingerprint = {
        HDMI-A-1-0 = "00ffffffffffff001e6d14775c1b00000c20010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a023a801871382d40582c45001e4e3100001e000000fd00384b1e5a19000a202020202020000000fc004c472048445220574648440a20018d020337f1230907074c100403011f1359da125d5e5f830100006d030c001000b83c20006001020367d85dc4013c8000e305c000e3060501295900a0a038274030203a001e4e3100001a565e00a0a0a02950302035001e4e3100001a000000ff00323132415a455230373030340a000000000000000000000000000000000000b0";
        HDMI-A-1-1 = "00ffffffffffff001e6d14775c1b00000c20010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a023a801871382d40582c45001e4e3100001e000000fd00384b1e5a19000a202020202020000000fc004c472048445220574648440a20018d020337f1230907074c100403011f1359da125d5e5f830100006d030c001000b83c20006001020367d85dc4013c8000e305c000e3060501295900a0a038274030203a001e4e3100001a565e00a0a0a02950302035001e4e3100001a000000ff00323132415a455230373030340a000000000000000000000000000000000000b0";
        HDMI-0 = "00ffffffffffff001e6d147748ec07000920010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a023a801871382d40582c45001e4e3100001e000000fd00384b1e5a19000a202020202020000000fc004c472048445220574648440a2001cc020337f1230907074c100403011f1359da125d5e5f830100006d030c001000b83c20006001020367d85dc4013c8000e305c000e3060501295900a0a038274030203a001e4e3100001a565e00a0a0a02950302035001e4e3100001a000000ff00323039415a4c5746393234300a00000000000000000000000000000000000084";
        DP-1 = "00ffffffffffff001e6d147748ec07000920010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a023a801871382d40582c45001e4e3100001e000000fd00384b1e5a19000a202020202020000000fc004c472048445220574648440a2001cc020337f1230907074c100403011f1359da125d5e5f830100006d030c001000b83c20006001020367d85dc4013c8000e305c000e3060501295900a0a038274030203a001e4e3100001a565e00a0a0a02950302035001e4e3100001a000000ff00323039415a4c5746393234300a00000000000000000000000000000000000084";
      };
    };

    hooks = {
      postswitch = {
    #    #"notify-i3" = "''${pkgs.i3}/bin/i3-msg restart";
    #    #"change-background" = builtins.readFile ./change-background.sh;
      };
    };

  };

  gui = {
    enable = true;
    # X for me
    bspwm = {
      enable = true;
      monitors = {
        ${left-monitor} = [ "1" "2" "3" "4" "5" ];
        ${right-monitor} = [ "6" "7" "8" "9" "0" ];
      };
    };
    polybar = {
      enable = true;
      script = ''
        MONITOR=${left-monitor} ${pkgs.polybar}/bin/polybar 21 --config=${config.xdg.configHome}/polybar/config.ini &
        MONITOR=${right-monitor} ${pkgs.polybar}/bin/polybar 22 --config=${config.xdg.configHome}/polybar/config.ini &
      '';
    };
    rofi.enable = true;
    dunst.enable = true;
    picom.enable = true;
    #redshift.enable = true;  # does not exist

    # X for people TODO
    #xfce.enable = true;

    # wayland
    #river.enable = true;  # this works, just `export WLR_NO_HARDWARE_CURSORS=1`
    #wofi.enable = true;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
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
      gnucash
      beancount
      fava
      xournalpp
      lua5_3
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
      tmsu    # tag based filesystem
      zotero  # paper organization
      conda
    ];
  };

}
