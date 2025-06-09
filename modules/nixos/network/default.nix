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

    enableGoogleDNSServers = mkOption {
      description = "Whether to use Google's DNS servers";
      type = with types; bool;
      default = false;
    };

    openssh = {
      enable = mkOption {
        description = "Whether to use OpenSSH or not";
        type = with types; bool;
        default = true;
      };
      settings.PermitRootLogin = mkOption {
        description = "Whether to permit root login for incoming sshs";
        type = with types; str;
        default = "no";
      };
    };

  };

  config = mkIf cfg.enable {

  #  services.openssh = {
  #    enable = cfg.openssh.enable;
  #    # require public key authentication for better security
  #    settings.PasswordAuthentication = false;
  #    settings.KbdInteractiveAuthentication = false;
  #    settings.PermitRootLogin = cfg.openssh.settings.PermitRootLogin;
  #  };

  #  programs.gnupg.agent.enableSSHSupport = true;

  #  environment.etc = mkIf cfg.enableGoogleDNSServers {
  #    "resolv.conf".text = ''
  #      nameserver 8.8.8.8
  #      nameserver 8.8.4.4
  #    '';
  #  };

  #  networking = {
  #    networkmanager.enable = true;

  #    interfaces = listToAttrs ( map (
  #      n: { name = "${n}"; value = { useDHCP = cfg.useDHCP; }; }
  #    ) cfg.interfaces);

  #    proxy = {
  #      #default = "http://user:password@proxy:port/";
  #      #noProxy = "127.0.0.1,localhost,internal.domain";
  #    };

  #    firewall = {
  #      enable = cfg.firewall.enable;
  #      #connectionTrackingModules = [ "pptp" ];
  #      #allowedTCPPorts = cfg.firewall.allowedTCPPorts;
  #      #allowedUDPPorts = cfg.firewall.allowedUDPPorts;
  #    };

  #    extraHosts = ''
  #      # Public
  #      #IP.ADDR hostname

  #      # VPN protected services
  #      #IP.ADDR hostname
  #    '';
  #  };

  };
}
