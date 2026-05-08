{ config, pkgs, lib, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "qylock-lock";
        before_sleep_cmd = "qylock-lock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl set 20%";
          on-resume = "brightnessctl set 100%";
        }
        {
          timeout = 600;
          on-timeout = "qylock-lock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
