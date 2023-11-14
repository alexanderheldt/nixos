{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernel = {
      sysctl = {
        "fs.inotify.max_user_instances" = 1024; # default: 128
      };
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };
}
