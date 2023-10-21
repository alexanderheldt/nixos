{  pkgs, lib, config, ... }:
let
  config-manager = let
    flakePath = config.config-manager.flakePath;
    nixosConfiguration = config.config-manager.nixosConfiguration;
  in
    if flakePath == "" then
      throw "'config-manager.flakePath' cannot be empty"
    else
      pkgs.writeShellScriptBin "cm" ''
        help() {
          cat << EOF
Usage:
  cm [flag]

Flags:
  --update    updates the flake
  --switch    rebuilds + switches configuration (using `nh`)
EOF
        }

        update() {
          echo -e "\033[0;31mUPDATING FLAKE\033[0m"
          sudo nix flake update
        }

        switch() {
          nh os switch --hostname ${nixosConfiguration} ${flakePath}
        }

        case $1 in
          --update)
            update ;;
          --switch)
            switch ;;
          --help | *)
            help ;;
    esac
      '';
in
{
  options = {
    config-manager = {
      flakePath = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "path to this flake";
      };

      nixosConfiguration = lib.mkOption {
        type = lib.types.str;
        default = config.networking.hostName;
        description = "what nixosConfiguration to use";
      };
    };
  };

  config = {
    environment.systemPackages = [ config-manager ];
  };
}
