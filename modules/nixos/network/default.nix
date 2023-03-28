{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.network;
in
{
  options.network = {
    enable = mkEnableOption "Whether to enable network configuration or not";

    interfaces = mkOption {
      description = "Network interfaces";
      type = with types; listOf str ;
      default = [ ];
      example = [ "enp2s0" "wlp3s0" ]; 
    };

    useDHCP = mkOption {
      description = "Whether to use DHCP or not";
      type = with types; bool;
      default = true;
    };

    sshServer = mkOption {
      description = "Whether to use OpenSSH or not";
      type = with types; bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ ]
      ++ lib.optional cfg.sshServer openssh;

    services.openssh.enable = cfg.sshServer;
    programs.gnupg.agent.enableSSHSupport = true;

    networking = {
      networkmanager.enable = true;

      interfaces = listToAttrs ( map (
        n: { name = "${n}"; value = { useDHCP = cfg.useDHCP; }; }
      ) cfg.interfaces);

      proxy = {
        #default = "http://user:password@proxy:port/";
        #noProxy = "127.0.0.1,localhost,internal.domain";
      };

      firewall = {
        connectionTrackingModules = [ "pptp" ];
        enable = false;
        #allowedTCPPorts = [ ... ];
        #allowedUDPPorts = [ ... ];
      };

      extraHosts = ''
        # Public
        #IP.ADDR hostname

        # VPN protected services
        #IP.ADDR hostname
      '';
    };

  };
}
