{ inputs, config, ... }:
let
  system = config.config-manager.system;
in
{
  age = {
    identityPaths = [ "/etc/ssh/sombrero" ];
  };

  environment.systemPackages = [
    inputs.agenix.packages."${system}".default
  ];
}
