{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    #steam
    #lutris
    #mangohud
    vlc

  ];

  #hardware.steam-hardware.enable = true;
  #hardware.graphics.enable32Bit = true;
}
