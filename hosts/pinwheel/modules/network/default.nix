{ ... }:
{
  services.connman = {
    enable = true;

    networkInterfaceBlacklist = [
      "vmnet"
      "vboxnet"
      "virbr"
      "ifb"
      "ve"
      "docker"
      "br-"
    ];
  };

  networking = {
    hostName = "pinwheel";

    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  };
}
