{ ... }:
{

  flake.nixosModules.desktop-utils =
    { pkgs, ... }:
    {
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      environment.systemPackages = with pkgs; [
        lxqt.lxqt-policykit
        pcmanfm
        glib
        xdg-utils
      ];
    };
}
