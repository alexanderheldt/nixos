{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.sombrero = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./hosts/sombrero/configuration.nix ];
    };
  };
}
