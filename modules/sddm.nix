{ config, pkgs, lib, ... }:

let
  clockwork-sddm = pkgs.stdenvNoCC.mkDerivation {
    name = "clockwork-sddm";
    src = pkgs.fetchFromGitHub {
      owner = "User-Aditya-Dhyani";
      repo = "qylock";
      rev = "main";
      sha256 = "sha256-az9oMO34GRk+2PwQ6gsr7aR3vZ3Hbj/O+cEQJshl2fo=";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/clockwork
      cp -r themes/clockwork/* $out/share/sddm/themes/clockwork/
      sed -i 's/color=#000000/color=#cc1009/' $out/share/sddm/themes/clockwork/theme.conf
    '';
  };
in
{
  services.displayManager.sddm = {
    wayland.enable = true;
    theme = "clockwork";
    extraPackages = with pkgs; [
    kdePackages.qtmultimedia
    kdePackages.qtdeclarative
    kdePackages.qt5compat
    kdePackages.qtsvg
    ];
  };

  environment.systemPackages = [ clockwork-sddm ];
}
