{ ... }:
{

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      size = 10;
    };

    settings = {
      windows_padding_width = 12;
      cursor_shape = "beam";
      enable_audio_bell = false;

      background_opacity = "0.6";
    };
  };

}
