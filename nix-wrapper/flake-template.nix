{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
    in
      {
        packages = nixpkgs.lib.genAttrs systems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            {
              # `derivation` may be filled out or switched
              # to something like `pkgs.buildGoModule`
              default = derivation {
                src = ./SRC_PATH;
              };

              hello = pkgs.hello;
            }
        );

        devShells = nixpkgs.lib.genAttrs systems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            {
              default = pkgs.mkShell {
                packages = [];
              };
            }
        );
      };
}
