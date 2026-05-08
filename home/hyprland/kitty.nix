{ config, pkgs, lib, ... }:
{
  programs.kitty = {
    font = {
      name = "JetBrains Mono";
      size = 10;
    };
    settings = {
      window_padding_width = 12;
      cursor_shape = "beam";
      enable_audio_bell = false;
      background_opacity = "0.68";
    };
    extraConfig = ''
      include ~/.config/kitty/skwd-theme.conf
    '';
  };
}
