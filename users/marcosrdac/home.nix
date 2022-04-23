{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";
  pathInDrv = path: let
      splitPath = pkgs.lib.strings.splitString "/" (builtins.toString path);
    in
      (builtins.concatStringsSep "/" (pkgs.lib.lists.sublist 4 ((builtins.length splitPath) - 4) splitPath));
  linkChildren = dir: linkdir: builtins.listToAttrs (
    map (filename: {
      name = "${linkdir}/${filename}";
      value = with config.lib.file; {
        source = mkOutOfStoreSymlink "${config.xdg.configHome}/nixpkgs/${pathInDrv dir}/${filename}";
      };
    }) (builtins.attrNames (builtins.readDir dir)));
in
{
  imports = [
    #./modules/module-a.nix
    #./modules/home-manager/shell
    #./modules/home-manager/graphics
    #./modules/home-manager/defaults
    #./modules/home-manager/appearance
    #./modules/home-manager/cloud
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
    neofetch

    p7zip
    zip

    ripgrep

    fzy

    scrot
    brightnessctl  # light control
    pamixer        # sound control

    julia_16-bin

    tmatrix

    keepassxc
    lxappearance
  ];

  home.sessionPath = [
    binHome
  ] ++ (builtins.attrNames (linkChildren ../../bin binHome));

  home.file = let
    mkLink = config.lib.file.mkOutOfStoreSymlink;
  in linkChildren ../../bin "${config.home.homeDirectory}/.local/bin";

  xdg.configFile = let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      "GIMP" = {
        source = ../../config/GIMP;
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
