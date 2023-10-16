{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.noto-fonts-emoji
    pkgs.nerdfonts
    pkgs.liberation_ttf
  ];
}
