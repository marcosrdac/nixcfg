{ pkgs, config, nixos, ... }:

{
  imports = [
    ./theme.nix
    ./redshift.nix
  ];
}
