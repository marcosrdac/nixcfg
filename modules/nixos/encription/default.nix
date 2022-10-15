{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.encryption;
in {

  options.encryption = {
    gpg = {
      enable = mkOption {
        description = "Whether to enable GPG agent or not";
        type = with types; bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.gpg.enable {
    programs.gnupg.agent.enable = true;
  };

}
