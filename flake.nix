{
  description = "nixos configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs2211.url = "github:nixos/nixpkgs/nixos-22.11";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, nixpkgs2211, agenix, nixos-hardware, home-manager, ... }: {
    nixosConfigurations = {
      pinwheel = let
        system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system agenix; };
        modules = [ 
          ./hosts/pinwheel/configuration.nix
          agenix.nixosModules.default
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alex = import ./hosts/pinwheel/home.nix;
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
