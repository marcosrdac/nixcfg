{ lib, pkgs, config, ... }:

{
  nix = {
    package = pkgs.nix;
    # TODO see if below is yet necessary
    extraOptions = ''experimental-features = nix-command flakes'';
  };
}
