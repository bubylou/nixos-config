{config, ...}: let
  nas01 = "100.64.0.3";
  nas02 = "100.64.0.4";
  oracle01 = "129.80.110.240";
in {
  boot = {
    supportedFilesystems = ["zfs"];
    zfs.extraPools = ["tank"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  services.zfs.autoScrub.enable = true;

  home-lab = {
    domain = "bubylou.com";

    authelia.enable = true;

    beszel-hub.enable = true;
    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/v5jX8oQ9lZzIgtX+b0BMJ6inyhZr/ta12w5Xs+mZg";
    };

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "headscale.bubylou.com" = oracle01;
        "jellyfin.bubylou.com" = nas02;
        "jellyseerr.bubylou.com" = nas02;
        "status.bubylou.com" = nas02;
        "bubylou.com" = nas01;
      };
    };

    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };

    lldap = {
      enable = true;
      ldapBaseDN = "dc=bubylou,dc=com";
      ldapHost = "0.0.0.0";
    };

    qbittorrent = {
      enable = true;
      volumes = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
        "/srv/share/Downloads:/downloads"
      ];
    };

    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking = {
    hostId = "6247a2a6";
    nameservers = ["127.0.0.1"];

    firewall = {
      allowedTCPPorts = [
        443
        80
        config.services.blocky.settings.ports.dns
      ];
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
      ];
    };
  };

  system.stateVersion = "25.05";
}
