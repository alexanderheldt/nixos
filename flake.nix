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

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self,  ... } @inputs : {
    nixosConfigurations = {
      pinwheel = let
        system = "x86_64-linux";
      in inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [ 
          ./hosts/pinwheel/configuration.nix
          inputs.agenix.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          inputs.home-manager.nixosModules.home-manager
          ./hosts/pinwheel/home.nix
          { nixpkgs.overlays = [ inputs.emacs-overlay.overlay ]; }
        ];
      };

      sombrero = inputs.nixpkgs2211.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/sombrero/configuration.nix ];
      };
    };
  };
}
