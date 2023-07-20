{
  description = "nixos configs";

  inputs = {
    nixpkgs2305.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs2211.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs2305";
  };
  
  outputs = { self, nixpkgs2305, nixpkgs2211, home-manager, ... }: {
    nixosConfigurations = {
      bennu = nixpkgs2305.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/bennu/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alex = import ./hosts/bennu/home.nix;
          }
        ];
      };

      sombrero = nixpkgs2211.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/sombrero/configuration.nix ];
      };
    };
  };
}
