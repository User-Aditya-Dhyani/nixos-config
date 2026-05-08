{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./fuzzel.nix
    ./waybar.nix
    ./kitty.nix
    ./hypridle.nix
    ./mako.nix
    ./neovim.nix
  ];
}
