{ pkgs, lib, config, ... }:
let
  enabled = config.mod.rust.enable;
in
{
  options = {
    mod.rust = {
      enable = lib.mkEnableOption "enable rust module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [
        pkgs.rustc
        pkgs.cargo
        pkgs.rustfmt
        pkgs.clippy
        pkgs.rust-analyzer
      ];
    };
  };
}
