{ inputs, pkgs, ... }:
{
  age = {
    identityPaths = [ "/etc/ssh/sombrero" ];
  };

  environment.systemPackages = [
    inputs.agenix.packages."${pkgs.system}".default
  ];
}
