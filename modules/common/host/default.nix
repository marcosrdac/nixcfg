{ pkgs, config, isNixos, ... }:

with pkgs.lib;
let
  cfg = config.host;
in
{
  options.host = {
    name = mkOption {
      type = with types; uniq str;
      description = "Host name";
      example = "marcos-desktop";
    };

    system = mkOption {
      type = with types; uniq str;
      description = "System architecture";
      default = "x86_64-linux";
      example = "x86_64-linux";
    };

    zone = mkOption {
      type = with types; uniq str;
      description = "Host time zone";
      default = "Brazil/East";
      example = "TODO";
    };

    locale = mkOption {
      type = with types; uniq str;
      description = "Host locale";
      default = "en_US.UTF-8";
      example = "TODO";
    };

    nixos = mkOption {
      type = with types; uniq str;
      description = "NixOS state version";
      default = "21.11";
      example = "21.05";
    };
  };

  config = if isNixos then {
    networking.hostName = cfg.name;
    time.timeZone = cfg.zone;
    system.stateVersion = cfg.nixos;
    i18n.defaultLocale = cfg.locale;
  } else {
    # TODO set anything up in home-manager? locale
  };
}
