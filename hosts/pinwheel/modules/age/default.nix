{ inputs, config, ... }:
let
  system = config.config-manager.system;
in
{
  age = {
    identityPaths = [
      "/etc/ssh/pinwheel"
      "/home/alex/.ssh/alex.pinwheel"
    ];
  };

  environment.systemPackages = [
    inputs.agenix.packages."${system}".default
  ];
}
