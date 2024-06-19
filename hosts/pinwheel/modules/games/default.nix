{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [
      pkgs.brogue-ce

      (pkgs.retroarch.override {
        cores = [
          pkgs.libretro.genesis-plus-gx
          pkgs.libretro.snes9x
          pkgs.libretro.dolphin
        ];
      })
    ];
  };
}
