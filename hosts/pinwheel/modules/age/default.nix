{ inputs, pkgs, ... }:
{
  age = {
    identityPaths = [
      "/etc/ssh/pinwheel"
      "/home/alex/.ssh/alex.pinwheel"
    ];
  };

  environment.systemPackages = [
    inputs.agenix.packages."${pkgs.system}".default
  ];
}
