{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Needed for swww and hyprlock
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  # Portal support for screen sharing etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    swww
    hyprlock
    hypridle
    hyprpicker        # color picker, useful for theming
    wl-clipboard      # clipboard for wayland
    cliphist          # clipboard history
    grim              # screenshots
    slurp             # region select for screenshots
    fuzzel
    mako
    waybar
    libnotify         # notify-send command
    brightnessctl     # screen brightness
    playerctl         # media key control
    hyprpolkitagent


    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtmultimedia
    libsForQt5.qt5.qtsvg
  ];

  environment.sessionVariables = {
    # Use Intel iGPU for Hyprland rendering
    WLR_DRM_DEVICES = "/dev/dri/card1";  # Intel card
    # Wayland specific
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
