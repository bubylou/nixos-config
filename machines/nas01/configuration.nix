{config, ...}: {
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["tank"];
  services.nfs.server.enable = true;

  home-lab = {
    domain = "sugondeez.com";

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "bubylou.com" = "192.168.1.11";
        "sugondeez.com" = "100.78.117.28";
      };
    };

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
