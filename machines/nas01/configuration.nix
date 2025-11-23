{config, ...}: {
  boot = {
    supportedFilesystems = ["zfs"];
    zfs.extraPools = ["tank"];
  };
  services.nfs.server.enable = true;

  home-lab = {
    domain = "bubylou.com";

    authelia.enable = true;

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "bubylou.com" = "100.93.143.35";
        "sugondeez.com" = "100.78.117.28";
      };
    };

    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };

    lldap = {
      enable = true;
      ldapBaseDN = "dc=bubylou,dc=com";
    };

    prowlarr.enable = true;
    radarr.enable = true;
    qbittorrent.enable = true;
    sonarr.enable = true;

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking = {
    hostId = "6247a2a6";
    nameservers = ["::1"];

    firewall = {
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
      ];
    };
  };

  system.stateVersion = "25.05";
}
