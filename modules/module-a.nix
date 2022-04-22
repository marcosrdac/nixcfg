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

  #config = mkIf config.test.enable {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome-dev
    ];
  };
}
