{ config, pkgs, lib, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      include = "/home/minun/.config/mako/skwd-colors.ini";
      border-radius = 10;
      border-size = 2;
      font = "JetBrains Mono Nerd Font 10";
      width = 320;
      height = 100;
      margin = "10";
      padding = "12";
      default-timeout = 5000;
      anchor = "bottom-right";
      layer = "overlay";

      "urgency=high" = {
        default-timeout=0;
      };
    };
  };
}
