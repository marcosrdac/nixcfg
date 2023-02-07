{ config, pkgs, ... }:

let
  domain = "test.marcosrdac.com";
  domainRoot = "/var/www/${domain}";
in {

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      root = "${domainRoot}";
    };
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
      title = "marcosrdac's test page";
      body = "This is just a test page.";
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
