{ config, pkgs, ... }:

{
  # DID NOT WORK: USING PARAVIRTUALIZATION INSTEAD OF ISCSI
  environment.systemPackages = [ pkgs.openiscsi ];

  #environment.etc = {
  #  "iscsi/iscsid.conf" = {
  #    text = pkgs.lib.fileContents "${pkgs.openiscsi}/etc/iscsi/iscsid.conf";
  #    mode = "0700";
  #  };
  #};

  systemd.services.iscsid = {
    description = "iscsid daemon";
    wantedBy = [ "basic.target" ];
    preStart = "${pkgs.kmod}/bin/modprobe iscsi_tcp";
    serviceConfig = {
      #ExecStart = "${pkgs.openiscsi}/bin/iscsid -f -c ${pkgs.openiscsi}/etc/iscsi/iscsid.conf -i ${pkgs.openiscsi}/etc/iscsi/initiatorname.iscsi";
      ExecStart = ''
        ${pkgs.openiscsi}/bin/iscsid -f -c ${./iscsid.conf} -i ${pkgs.openiscsi}/etc/iscsi/initiatorname.iscsi
        sudo iscsiadm -m node -o new -T iqn.2015-12.com.oracleiaas:7b3bc0ac-8f76-4d30-b26b-1cbd3304b3a0 -p 169.254.2.2:3260
        sudo iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:7b3bc0ac-8f76-4d30-b26b-1cbd3304b3a0 -n node.startup -v automatic
        sudo iscsiadm -m node -T iqn.2015-12.com.oracleiaas:7b3bc0ac-8f76-4d30-b26b-1cbd3304b3a0 -p 169.254.2.2:3260 -l
      '';
      KillMode = "process";
      #Restart = "on-success";
      Restart = "always";
    };
  };

  #boot.iscsi-initiator = {
  #  name = "test";
  #  extraIscsiCommands = ''
  #    sudo iscsiadm -m node -o new -T iqn.2015-12.com.oracleiaas:7b3bc0ac-8f76-4d30-b26b-1cbd3304b3a0 -p 169.254.2.2:3260
  #    sudo iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:7b3bc0ac-8f76-4d30-b26b-1cbd3304b3a0 -n node.startup -v automatic
  #    sudo iscsiadm -m node -T iqn.2015-12.com.oracleiaas:7b3bc0ac-8f76-4d30-b26b-1cbd3304b3a0 -p 169.254.2.2:3260 -l
  #  '';
  #};

}
