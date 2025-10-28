{ config, ... }:

{
  imports = [ ./disk-config.nix ./hardware-configuration.nix ];

  networking = {
    nameservers = [ "127.0.0.1" "100.100.100.100" "1.1.1.1" ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];

      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
        config.services.tailscale.port
      ];
    };
  };

  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/nfs/share" = {
    device = "nas01.bubylou.com:/srv/share";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };

  home-lab = {
    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "bubylou.com" = "192.168.1.11";
        "sugondeez.com" = "100.78.117.28";
      };
    };

    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };

    jellyfin = { enable = true; };
  };

  system.stateVersion = "25.05";
}
