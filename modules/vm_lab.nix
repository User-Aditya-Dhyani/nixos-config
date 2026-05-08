{ config, lib, ... }:

{
  config = lib.mkIf (config.networking.hostName == "nixos") {

    fileSystems."/vm-store" = {
      device = "/dev/disk/by-uuid/70e7a87e-83e6-47c8-8321-9b01b16d29ac";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/afa192d5-99f4-47e1-aaab-f93804fb9c44";}
    ];

    virtualisation.virtualbox.host.enable = true;
    users.users.minun.extraGroups = [ "networkmanager" "wheel" "vboxusers" ];

  };

}
