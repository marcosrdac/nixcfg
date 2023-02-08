
  #virtualisation.oci-containers = {
  #  backend = "docker";
  #  containers = {
  #    collabora = {
  #      image = "collabora/code:22.05.10.1.1";
  #      #image = "collabora/code:latest";
  #      #host_port:container_port
  #      #ports = [ "443:9980" ];
  #      #ports = [ "9980:9980" ];
  #      ports = [ "9980:9980" ];
  #      environment = {
  #        username = "admin";
  #        password = "${passDir}/collabora";
  #        dictionaries = "en_US,pt-br";
  #        domain = "collabora.${domain}";
  #        extra_params = "--o:ssl.enable=false";
  #      };
  #    };
  #    #onlyoffice = {
  #    #  image = "onlyoffice/documentserver";
  #    #  ports = [ "9981:80" ];
  #    #};
  #  };
  #};
