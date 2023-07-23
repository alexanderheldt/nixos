{
  description = "nixos configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs2305.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs2211.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, nixpkgs2305, nixpkgs2211, nixos-hardware, home-manager, ... }: {
    nixosConfigurations = {
      pinwheel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          ./hosts/pinwheel/configuration.nix
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
