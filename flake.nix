{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = inputs@{ self, nixpkgs }: {
    nixosConfigurations.sombrero = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./hosts/sombrero/configuration.nix ];
    };
  };
}
