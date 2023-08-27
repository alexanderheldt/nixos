{
  description = "nixos configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs2211.url = "github:nixos/nixpkgs/nixos-22.11";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, nixpkgs2211, nixos-hardware, home-manager, agenix, ... }: {
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
