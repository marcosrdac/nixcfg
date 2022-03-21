{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotDir = "${config.xdg.configHome}/nixpkgs";
  dotConfig = "${dotDir}/config";
  linkChildren = (
    dir: linkdir: builtins.listToAttrs (
    map (filename: {
      name = "${linkdir}/${filename}";
      value = with config.lib.file; {
        source = mkOutOfStoreSymlink ("${dir}/${filename}");
      };
    }) (builtins.attrNames (builtins.readDir dir)))
  );
in {

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    #profilePath = ".hm-profile";
    profileExtra = "${pkgs.pywal}/bin/wal -i $HOME/tmp &";
  };

  xsession.windowManager.bspwm = {
    enable = true;
    extraConfig = builtins.readFile ../../config/bspwm/bspwmrc;
    startupPrograms = [
      "${pkgs.sxhkd}/bin/sxhkd -c ${config.xdg.configHome}/sxhkd/sxhkdrc"
    ];
  };


  home.file = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      # bspwm
      "${binHome}/bspwm_window_move".source = mkLink "${dotConfig}/bspwm/bin/bspwm_window_move";
      "${binHome}/bspwm_toggle_state".source = mkLink "${dotConfig}/bspwm/bin/bspwm_toggle_state";
    } // (linkChildren ../../config/bspwm/bin "${binHome}/bspwm");

  services.picom = {
    enable = true;
    #package = pkgs.unstable.picom;
    package = pkgs.picom;
    activeOpacity = "1.0";
    menuOpacity = "1.0";
    inactiveOpacity = "1.0";
    inactiveDim = "0.0";  # 0.2 before
    blur = true;
    backend = "glx";
    refreshRate = 0;
    experimentalBackends = true;
    fade = false;
    fadeDelta = 10;
    fadeSteps = [ "0.028" "0.03" ];
    shadow = false;
    shadowOpacity = "0.75";
    shadowOffsets = [ (-15) (-15) ];  # H&V
    opacityRule = [
      "90:class_g = 'St' && focused"
      "90:class_g = 'Alacritty' && focused"
      "90:class_g = 'dmenu' && focused"
      "90:class_g = 'Polybar'"
      "90:class_g = 'Spotify' && focused"
      #"90:class_g = 'Zathura' && focused"
      "90:class_g = 'tchoice' && focused"
      "90:class_g = 'dropdown_terminal' && focused"
      "90:class_g = 'dropdown_calculator' && focused"
      "90:class_g = 'dropdown_mail' && focused"
      "90:class_g = 'dropdown_music_player' && focused"
      #"90:class_g = 'qutebrowser' && focused"
      "80:class_g = 'St' && !focused"
      "80:class_g = 'Alacritty' && !focused"
      "80:class_g = 'dmenu' && !focused"
      "80:class_g = 'Spotify' && !focused"
      #"80:class_g = 'Zathura' && !focused"
      "80:class_g = 'tchoice' && !focused"
      "80:class_g = 'dropdown_terminal' && !focused"
      "80:class_g = 'dropdown_calculator' && !focused"
      "80:class_g = 'dropdown_mail' && !focused"
      "80:class_g = 'dropdown_music_player' && !focused"
      #"80:class_g = 'qutebrowser' && !focused"
    ];
    blurExclude = [ ];
    fadeExclude = [ ];
    shadowExclude = [ ];
    noDockShadow = true;
    extraOptions = ''
      no-ewmh-fullscreen = true;

      #blur-method = "dual_kawase"
      #blur-strength = 3
      blur-method = "gaussian"
      blur-size = 9
      blur-deviation = 10

      #corner-radius = 1
    '';
  };

}
