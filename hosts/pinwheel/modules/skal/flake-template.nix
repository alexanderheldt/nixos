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
          # let
          #   pkgs = nixpkgs.legacyPackages.${system};
          # in
            {
              default = {
                src = SRC_PATH;
              };
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
