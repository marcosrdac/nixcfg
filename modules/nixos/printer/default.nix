{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.printer;
in
{
  options.printer = {
    enable = mkEnableOption "Enable default printing configuration";

    drivers = mkOption {
      description = "Extra printing drivers";
      type = with types; listOf package;
      default = [ ];
      example = ''[ pkgs.epson-escpr ]'';
    };
  };

  config = mkIf cfg.enable {

    # wifi printing
    services.printing.browsing = true;
    services.printing.browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All

      BrowseProtocols all
         '';
    services.avahi = {
      enable = true;
      nssmdns = true;
    };
    #

    services.printing.enable = true;
    services.printing.drivers = with pkgs; cfg.drivers ++ [
      gutenprint gutenprintBin
    ];

    environment.systemPackages = with pkgs; [
      system-config-printer
      gutenprint gutenprintBin #=: escputil: maintenance
    ];
  };
}
