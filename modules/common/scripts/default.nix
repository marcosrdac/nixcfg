{ config, pkgs, ... }:

let
  binHome = "${config.home.homeDirectory}/.local/bin";

  linkChildren = dir: linkdir: let
    pathInDrv = path: let
        splitPath = pkgs.lib.strings.splitString "/" (builtins.toString path);
      in
        (builtins.concatStringsSep "/" (pkgs.lib.lists.sublist 4 ((builtins.length splitPath) - 4) splitPath));
  in builtins.listToAttrs (
    map (filename: {
      name = "${linkdir}/${filename}";
      value = with config.lib.file; {
        source = mkOutOfStoreSymlink "${config.xdg.configHome}/nixpkgs/${pathInDrv dir}/${filename}";
      };
    }) (builtins.attrNames (builtins.readDir dir)));
in
{
  home.sessionPath = (map (n: "${builtins.toString ./bin}/${n}") (builtins.attrNames (builtins.readDir ./bin))) ++ [
    binHome
  ];

  #  home.sessionVariables = let
  #    myscript = pkgs.writeShellScriptBin "myscpt" ''
  #      #!/usr/bin/env sh
  #      echo hello world
  #    '';
  #    mkNixConfigFunction = pkgs.writeShellScriptBin "mkNixConfigFunction" ''
  #      #!/usr/bin/env sh
  #      [ -e default.nix ] || (echo "{ config, pkgs, ... }:\n\n{\n\n}" > default.nix)
  #    '';
  #    in {
  #      MYSCRIPT = "${myscript}/bin/myscpt";
  #      MKNIXCONFIGFUNCTION = "${mkNixConfigFunction}/bin/mkNixConfigFunction";
  #    };

}
