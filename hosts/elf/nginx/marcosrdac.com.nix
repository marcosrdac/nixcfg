{ config, pkgs, ... }:

let
  domain = "marcosrdac.com";
  domainRoot = "/var/www/${domain}";
in {

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      root = "${domainRoot}";
    };
    #"*.${domain}" = {
      #globalRedirect = "${domain}";
    #};
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  security.acme.certs = {
    "${domain}" = {
      email = "mail@marcosrdac.com";
    };
  };

  system.activationScripts."makeFilesFor<${domain}>" = let
    makeHtml = title: body: ''
      <!DOCTYPE html>
      <html>
        <body>
          <h1>${title}</h1>
          <p>${body}</p>
        </body>
      </html>
      '';
  in {
    deps = [ "var" ];
    text = let
      title = "marcosrdac's home page";
      body = "In maintenance...";
    in ''
      domain_root="${domainRoot}"
      domain_index="$domain_root/index.html"
      [ -f "$domain_index" ] && exit 0
      mkdir -p "$domain_root"
      echo "${makeHtml title body}" >> "$domain_index"
      chown -R "${config.services.nginx.user}" "$domain_root"
    '';
  };

}
