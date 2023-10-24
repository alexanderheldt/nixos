{
  networking = {
    hostName = "sombrero";

    defaultGateway = "192.168.50.1";
    nameservers = [ "8.8.8.8" ];
    interfaces = {
      eth0 = {
        ipv4 = {
          addresses = [{
            address = "192.168.50.200";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
