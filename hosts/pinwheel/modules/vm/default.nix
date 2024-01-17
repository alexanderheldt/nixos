{ pkgs, lib, config, ... }:
let
  enabled = config.mod.vm.enable;
in
{
  options = {
    mod.vm = {
      enable = lib.mkEnableOption "add vm module";
    };
  };

  config = lib.mkIf enabled {
    virtualisation.libvirtd.enable = true;

    users.users.alex = {
      extraGroups = [ "libvirtd" ];
    };

    # virt-manager requires dconf to remember settings
    programs.dconf.enable = true;
    programs.virt-manager.enable = true;

    home-manager.users.alex = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
