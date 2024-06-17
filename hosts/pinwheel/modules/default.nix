{ lib, ... }:
let
  toModulePath = dir: _: ./. + "/${dir}";
  filterDirs = dirs: lib.attrsets.filterAttrs (_: type: type == "directory") dirs;
in
{
  imports = lib.mapAttrsToList toModulePath (filterDirs (builtins.readDir ./.));

  config = {
    mod = {
      bluetooth.enable = true;
      nix-index.enable = false;
      greetd.enable = true;
      hyprland.enable = true;
      swaylock.enable = true;
      physlock.enable = false;
      power.enable = true;

      wezterm.enable = false;
      foot.enable = true;

      git.enable = true;
      zsh.enable = true;
      openvpn.enable = true;

      c.enable = true;
      go.enable = true;
      rust.enable = true;
      scala.enable = true;
      python.enable = true;

      keyboard.enable = true;
      containers = {
        docker.enable = true;
        podman.enable = false;
      };
      vm.enable = true;
      scripts.enable = true;
      pppdotpm-site.enable = false;
    };
  };
}
