{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  dotConfig = ./config;
  dotBin = ./bin;
  linkChildren = dir: linkdir: builtins.listToAttrs (
    map (filename: {
      name = "${linkdir}/${filename}";
      value = with config.lib.file; {
        #source = mkOutOfStoreSymlink "${builtins.toString dir}/${filename}";
        source = mkOutOfStoreSymlink (dir + "/${filename}");
        #source = mkOutOfStoreSymlink "${dir}/${filename}";
        #source = mkOutOfStoreSymlink ./. + dir + filename ;
        #source = mkOutOfStoreSymlink dir + "/${filename}" ;
        #source = mkOutOfStoreSymlink dir/${filename};
        #source = config.lib.file.mkOutOfStoreSymlink "${builtins.toString dir}/${filename}";
      };
    }) (builtins.attrNames (builtins.readDir dir)));
in
{
  imports = [
    ./modules/shell
    ./modules/graphics
    ./modules/defaults
    ./modules/appearance
  ];

  services.network-manager-applet.enable = true;

  home.keyboard = {
    #layout = "br";
    layout = "us";
    variant = "intl";
    options = [ "caps:swapescape" ];
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    #(callPackage (import ./packages/nvim) {})
    nox
    scrot

    ripgrep

    fzy

    brightnessctl  # light control
    pamixer        # sound control

    julia_16-bin

    tmatrix
  ];


  home.sessionPath = [
    binHome
  ] ++ (builtins.attrNames (linkChildren ./bin binHome));


  home.file = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      asd.source = mkLink ./home.nix;
    } // linkChildren ./bin ".local/bin";

  xdg.configFile = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      "GIMP" = {
        source = ./config/GIMP;
        recursive = true;
    };
  };

  # test stuff

  home.sessionVariables = let
    myscript = pkgs.writeShellScriptBin "myscpt" ''
      #!/usr/bin/env sh
      echo hello world
    '';
    mkNixConfigFunction = pkgs.writeShellScriptBin "mkNixConfigFunction" ''
      #!/usr/bin/env sh
      [ -e default.nix ] || (echo "{ config, pkgs, ... }:\n\n{\n\n}" > default.nix)
    '';
    in {
      MYSCRIPT = "${myscript}/bin/myscpt";
      MKNIXCONFIGFUNCTION = "${mkNixConfigFunction}/bin/mkNixConfigFunction";
    };

}
