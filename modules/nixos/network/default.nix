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

    firewall = {
      enable = mkEnableOption "Whether to use firewall";
    };

    useDHCP = mkOption {
      description = "Whether to use DHCP or not";
      type = with types; bool;
      default = true;
    };

    openssh = {
      enable = mkOption {
        description = "Whether to use OpenSSH or not";
        type = with types; bool;
        default = true;
      };
      permitRootLogin = mkOption {
        description = "Whether to permit root login for incoming sshs";
        type = with types; str;
        default = "no";
      };
    };
  };

  config = mkIf cfg.enable {

    services.openssh = {
      enable = cfg.openssh.enable;
      # require public key authentication for better security
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = cfg.openssh.permitRootLogin;
    };

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
        enable = cfg.firewall.enable;
        #connectionTrackingModules = [ "pptp" ];
        #allowedTCPPorts = cfg.firewall.allowedTCPPorts;
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
