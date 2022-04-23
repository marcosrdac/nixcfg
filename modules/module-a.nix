{ config, pkgs, ... }:

with pkgs.lib;
let
  cfg = config.test-abc;
in
{
  imports = [
    # paths to other modules
  ];

  options.test-abc = {
    enable = mkEnableOption "A test enable";
  };

  config = {
    home.packages = mkIf cfg.enable (with pkgs; [
      google-chrome-dev
    ]);
  };
}
