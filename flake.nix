{
  description = "nixos configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self,  ... }@inputs: {
    nixosConfigurations = {
      pinwheel = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/pinwheel/configuration.nix
          inputs.agenix.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
          inputs.home-manager.nixosModules.home-manager
          ./hosts/pinwheel/home.nix
          { nixpkgs.overlays = [ inputs.emacs-overlay.overlay ]; }
        ];
      };

      sombrero = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/sombrero/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          ./hosts/sombrero/home.nix
        ];
      };
    };
  };
}
