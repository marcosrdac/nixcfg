{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.controllers;
in
{
  options.controllers = {
    enable = mkEnableOption "Enable default controller configuration";
  };

  config = mkIf cfg.enable { };
}
