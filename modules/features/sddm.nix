{ ... }:
{

  flake.nixosModules.sddm =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        wayland.compositor = "kwin";

        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";

        extraPackages = with pkgs; [
          kdePackages.qtmultimedia
          kdePackages.qtsvg
          kdePackages.qtvirtualkeyboard

          sddm-astronaut
          bibata-cursors-translucent
        ];

        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
            CursorTheme = "Bibata-Modern-Ice";
            CursorSize = 16;
          };
        };
      };

      environment.systemPackages = with pkgs; [
        sddm-astronaut
        bibata-cursors
        kdePackages.qtmultimedia
      ];
    };

}
