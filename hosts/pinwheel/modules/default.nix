{ lib, ... }:
let
  toModulePath = dir: _: ./. + "/${dir}";
  filterDirs = dirs: lib.attrsets.filterAttrs (_: type: type == "directory") dirs;
in
{
  imports = lib.mapAttrsToList toModulePath (filterDirs (builtins.readDir ./.));
}
