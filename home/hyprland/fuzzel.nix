{ config, pkgs, lib, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
	include = "/home/minun/.config/fuzzel/skwd-colors.ini";
        font = "JetBrains Mon Nerd Font:size=10";
        prompt = " ";
        terminal = "kitty";
        width = 40;
        lines = 10;
        border-radius = 10;
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}
