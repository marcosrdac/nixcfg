{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.printer;
in
{
  options.printer = {
    enable = mkOption {
      description = "Enable default printing configuration";
      type = with types; bool;
      default = true;
    };

    drivers = mkOption {
      description = "Extra printing drivers";
      type = with types; listOf package;
      default = [ ];
      example = ''[ pkgs.epson-escpr ]'';
    };
  };

  config = mkIf cfg.enable {

    services.printing = {
      enable = true;
      drivers = with pkgs; cfg.drivers ++ [
	gutenprint
      ];
    };

    environment.systemPackages = with pkgs; [
      gutenprint  #=: escputil: maintenance
    ];
  };
}
