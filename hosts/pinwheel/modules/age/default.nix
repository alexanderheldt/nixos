{ inputs, pkgs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  config = {
    age = {
      identityPaths = [
        "/etc/ssh/pinwheel"
        "/home/alex/.ssh/alex.pinwheel"
      ];
    };

    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];
  };
}
