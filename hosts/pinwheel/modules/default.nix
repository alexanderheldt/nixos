{ lib, ... }:
let
  toModulePath = dir: _: ./. + "/${dir}";
  filterDirs = dirs: lib.attrsets.filterAttrs (_: type: type == "directory") dirs;
in
{
  imports = lib.mapAttrsToList toModulePath (filterDirs (builtins.readDir ./.));

  config = {
    mod = {
      nix-index.enable = false;
      greetd.enable = true;
      hyprland.enable = true;
      swaylock.enable = true;
      physlock.enable = false;
      tlp.enable = true;
      wezterm.enable = true;
      foot.enable = false;
      git.enable = true;
      openvpn.enable = true;
      go.enable = true;
      rust.enable = true;
      keyboard.enable = true;
      docker.enable = true;
      podman.enable = false;
      vm.enable = true;
      scripts.enable = true;
      pppdotpm-site.enable = false;
    };
  };
}
