{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;

        margin-top = 0;
        margin-left = 0;
        margin-right = 0;

        modules-left   = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right  = [ "pulseaudio" "network" "battery" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        network = {
          format-wifi = "󰤨 {signalStrength}%";
          format-disconnected = "󰤭 offline";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
        };

        tray = {
          spacing = 8;
        };
      };
    };
style = ''
  @import "/home/minun/.config/waybar/colors.css";

  * {
    font-family: "JetBrains Mono Nerd Font";
    font-size: 13px;
    min-height: 0;
    border: none;
    border-radius: 0;
  }

  window#waybar {
    background-color: alpha(@surface_container, 0.85);
    color: @on_surface;
    border-bottom: 1px solid @primary;
  }

  #workspaces button {
    padding: 0 8px;
    color: @on_surface_variant;
    background: transparent;
    border-radius: 4px;
    margin: 4px 2px;
  }

  #workspaces button.active {
    color: @on_surface;
    background: alpha(@surface_container, 0.85);
    border-bottom: 2px solid @primary;
  }

  #workspaces button:hover {
    background: alpha(@surface_container, 0.85);
    color: @on_surface;
  }

  #clock {
    color: @tertiary;
    font-weight: bold;
    padding: 0 12px;
  }

  #battery {
    color: @tertiary;
    padding: 0 8px;
  }

  #battery.warning {
    color: @primary;
  }

  #battery.critical {
    color: @error;
    animation: blink 0.5s steps(1) infinite;
  }

  @keyframes blink {
    to { color: transparent; }
  }

  #network {
    color: @on_surface_variant;
    padding: 0 8px;
  }

  #pulseaudio {
    color: @on_surface_variant;
    padding: 0 8px;
  }

  #pulseaudio.muted {
    color: @outline;
  }

  #tray {
    padding: 0 8px;
  }

  tooltip {
    background: @surface;
    border: 1px solid @primary;
    border-radius: 8px;
    color: @on_surface;
  }
'';
  };
}
