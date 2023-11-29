{ inputs, pkgs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  config = {
    age = {
      identityPaths = [ "/etc/ssh/sombrero" ];
    };

    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];
  };
}
