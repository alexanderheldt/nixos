{ inputs, lib, config, ... }:
let
  enabled = config.mod.pppdotpm-site.enable;
in
{
  imports = [ inputs.pppdotpm-site.nixosModules.default ];

  options = {
    mod.pppdotpm-site = {
      enable = lib.mkEnableOption "enable ppp.pm site";
    };
  };

  config = lib.mkIf enabled {
    services.pppdotpm-site = {
      enable = true;
      domain = "ppp.pm.local";
    };

    networking.extraHosts = "127.0.0.1 ppp.pm.local";
  };
}
