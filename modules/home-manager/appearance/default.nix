{ pkgs, config, isNixos, ... }:

{
  imports = [
    ./theme.nix
    ./redshift.nix
  ];
}
