{ config, pkgs, lib, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "qylock-lock";
        before_sleep_cmd = "qylock-lock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
	ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "qylock-lock";
        }
#        {
#          timeout = 900;
#          on-timeout = "hyprctl dispatch dpms off";
#          on-resume = "hyprctl dispatch dpms on";
#        }
      ];
    };
  };
}
