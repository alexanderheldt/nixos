{ pkgs, lib, config, ... }:
let
  enabled = config.mod.scala.enable;
in
{
  options = {
    mod.scala = {
      enable = lib.mkEnableOption "enable scala module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [
        pkgs.scala-cli
        (pkgs.scala_2_13.override { jre = pkgs.jdk17; })
        (pkgs.sbt.override { jre = pkgs.jdk17; })
        (pkgs.metals.override { jre = pkgs.jdk17; })
      ];
    };
  };
}
