{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 3;
	"col.active_border" = "rgba(cc1009ff)";
        "col.inactive_border" = "rgba(5d3f3baa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
	blur = {
	  enabled = true;
	  size = 8;
	  passes = 2;
	  vibrancy = 0.2;
	};
        shadow = {
	  enabled = false;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      monitor = [
	"eDP-1, 1920x1080@144, 0x0, 1"
      ];

      # Tell Hyprland to use Intel iGPU for rendering
      env = [
        "WLR_DRM_DEVICES,/dev/dri/card1"
      ];

      # Basic input config
      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      layerrule = [
#	"blur, kitty"
	"blur, wallpaper-selector-parallel"
	"ignorezero, wallpaper-selector-parallel"
      ];

      # Modifier key - Windows key
      "$mod" = "SUPER";

      # Keybinds - just the essentials
      bind = [
        "$mod, Return, exec, kitty"    # open terminal
        "$mod, Q, killactive"          # close window
        "$mod, M, exit"                # exit Hyprland
        "$mod, Space, exec, fuzzel"    # open app launcher 
	"$mod SHIFT ALT, B, exec, pkill -SIGUSR1 waybar"  # waybar toggle
	"$mod, L, exec, qylock-lock"
	"$mod, W, exec, skwd-wall"

	# Workspaces
	"$mod, 1, focusworkspaceoncurrentmonitor, 1"
	"$mod, 2, focusworkspaceoncurrentmonitor, 2"
	"$mod, 3, focusworkspaceoncurrentmonitor, 3"

	"$mod SHIFT, 1, movetoworkspace, 1"
	"$mod SHIFT, 2, movetoworkspace, 2"
	"$mod SHIFT, 3, movetoworkspace, 3"

	# Focus movement
	"$mod, left, movefocus, l"
	"$mod, right, movefocus, r"
	"$mod, up, movefocus, u"
	"$mod, down, movefocus, d"

	# Move windows
	"$mod SHIFT, left, movewindow, l"
	"$mod SHIFT, right, movewindow, r"
	"$mod SHIFT, up, movewindow, u"
	"$mod SHIFT, down, movewindow, d"

	# Fullscreen and float
	"$mod, F, fullscreen"
	"$mod, V, togglefloating"

	# Screen Cycling
	"ALT, Tab, cyclenext"
	"ALT SHIFT, Tab, cyclenext, prev"

	# Screenshot-copy
	",Print, exec, grim -g \"$(slurp)\" - | wl-copy"
	# Screenshot
	"$mod, Print, exec, grim - | wl-copy"
	# Clipboard history
	"$mod, C, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
	"$mod SHIFT, C, exec, cliphist wipe"
	# Color pick
	"$mod, K, exec, hyprpicker -a"

      ];

      bindl = [
	",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%+"
	",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-"
	",XF86MonBrightnessUp, exec, brightnessctl set 4%+"
	",XF86MonBrightnessDown, exec, brightnessctl set 4%-"
	",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
	",XF86AudioPlay, exec, playerctl play-pause"
	",XF86AudioNext, exec, playerctl next"
	",XF86AudioPrev, exec, playerctl previous"
	"$mod SHIFT, Escape, exec, loginctl unlock-session"
      ];

      bindm = [
	"$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindows"
      ];

      exec-once = [
	"waybar"
	"skwd-daemon"
	"wl-paste --type text --watch cliphist store"
	"wl-paste --type image --watch cliphist store"
	"hypridle"
      ];
    };
  };
}
