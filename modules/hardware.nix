{ ... }:
{

  flake.nixosModules.hardware =
    { ... }:
    {

      services.thermald.enable = true;
      powerManagement.enable = true;
      services.upower.enable = true;
      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MAX_PERF_ON_BAT = 75;

          CPU_SCALING_GOVERNOR_ON_SAV = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
          CPU_MIN_PERF_ON_SAV = 0;
          CPU_MAX_PERF_ON_SAV = 30;

          START_CHARGE_THRESH_BAT0 = 20;
          STOP_CHARGE_THRESH_BAT0 = 80;
        };
      };

      # services.xserver.videoDrivers = [ "nvidia" ];
      # hardware.nvidia = {
      #   modesetting.enable = true;
      #   powerManagement.enable = true;
      #   powerManagement.finegrained = true;
      #   open = false;
      #   nvidiaSettings = true;
      #   prime = {
      #     offload = {
      #       enable = true;
      #       enableOffloadCmd = true;
      #     };
      #     intelBusId = "";
      #     nvidiaBusId = "";
      #   };
      # };

      services.fwupd.enable = true;

      services.earlyoom = {
        enable = true;
        freeMemThreshold = 2;
        freeSwapThreshold = 10;
      };
    };

}
