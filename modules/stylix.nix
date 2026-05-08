{ pkgs, lib, ... }:
let
  sources = import /etc/nixos/npins;
in
{
  imports = [ (import sources.stylix).nixosModules.stylix ];

  stylix = {
    enable = true;
    image = /home/minun/Pictures/wallpaper/wallhaven-4xpydd.jpg;
    polarity = "dark";
    base16Scheme = {
      base00 = "1f0f0c";
      base01 = "2d1b18";
      base02 = "392522";
      base03 = "5d3f3b";
      base04 = "ad8882";
      base05 = "fddbd6";
      base06 = "e7bdb6";
      base07 = "fff8f6";
      base08 = "cc1009";
      base09 = "f8bc60";
      base0A = "ffb4a8";
      base0B = "8b5d00";
      base0C = "ad8882";
      base0D = "930001";
      base0E = "8c2016";
      base0F = "44302c";
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        applications = 12;
        terminal = 12;
      };
    };
  };
}
