{ lib, pkgs, config, ... }:

{
  nix = {
    package = pkgs.nix;
    extraOptions = ''experimental-features = nix-command flakes'';
  };
}
