{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.encription;
in {

  options.encription = {
    enable = mkOption {
      description = "Whether to enable GPG agent or not";
      type = with types; bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent.enable = true;
  };

}
