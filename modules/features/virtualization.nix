{ ... }:
{
  flake.nixosModules.virtSetup =
    { pkgs, ... }:
    let
      defaultNetworkXML = pkgs.writeText "libvirt-default-network.xml" ''
        <network>
          <name>default</name>
          <forward mode='nat'/>
          <bridge name='virbr0' stp='on' delay='0'/>
          <ip address='192.168.122.1' netmask='255.255.255.0'>
            <dhcp>
              <range start='192.168.122.2' end='192.168.122.254'/>
              </dhcp>
          </ip>
        </network>
      '';
    in
    {

      programs.virt-manager.enable = true;
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;

      users.users.minun.extraGroups = [
        "libvirtd"
        "kvm"
      ];

      environment.systemPackages = [ pkgs.dnsmasq ];

      systemd.services.libvirtd-default-net = {
        description = "Define, autostart, and activate libvirt default network";
        after = [ "libvirtd.service" ];
        requires = [ "libvirtd.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          ${pkgs.libvirt}/bin/virsh net-define ${defaultNetworkXML} || true
          ${pkgs.libvirt}/bin/virsh net-autostart default || true
          ${pkgs.libvirt}/bin/virsh net-start default || true
        '';

        preStop = ''
          ${pkgs.libvirt}/bin/virsh net-destroy default || true
          ${pkgs.libvirt}/bin/virsh net-autostart --disable default || true
          ${pkgs.libvirt}/bin/virsh net-undefine default || true
        '';
      };

    };
}
