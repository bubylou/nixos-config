{
  pkgs,
  config,
  ...
}: {
  networking = {
    nameservers = ["::1"];

    firewall = {
      allowedTCPPorts = [
        config.home-lab.lldap.ldapPort
      ];
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
        config.services.minecraft-servers.servers.paper.serverProperties.server-port
      ];
    };
  };

  boot.supportedFilesystems = ["nfs"];
  fileSystems."/mnt/nfs/share" = {
    device = "nas01.bubylou.com:/srv/share";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto"];
  };

  hardware.nvidia-container-toolkit.enable = true;

  home-lab = {
    domain = "sugondeez.com";

    authelia.enable = true;

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

    gatus.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;

    lldap = {
      enable = true;
      ldapBaseDN = "dc=sugondeez,dc=com";
    };

    minecraft = {
      enable = true;
      package = pkgs.paperServers.paper-1_21_10;
      difficulty = 2;
      operators = {Bubylou = "7fd923ac-5f25-456c-bc0b-48b0bed3bd40";};
      whitelist = {Bubylou = "7fd923ac-5f25-456c-bc0b-48b0bed3bd40";};
    };

    prowlarr.enable = true;
    radarr.enable = true;
    qbittorrent = {
      enable = true;
      port = 8081;
    };
    sonarr.enable = true;

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  system.stateVersion = "25.05";
}
