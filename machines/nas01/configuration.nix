{config, ...}: let
  nas01 = "100.93.143.35";
  nas02 = "100.78.117.28";
in {
  boot = {
    supportedFilesystems = ["zfs"];
    zfs.extraPools = ["tank"];
  };

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

    prowlarr.enable = true;
    qbittorrent = {
      enable = true;
      volumes = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
        "/srv/share/Downloads:/downloads"
      ];
    };
    radarr = {
      enable = true;
      volumes = [
        "radarr_data:/config"
        "/srv/share/Downloads:/downloads"
        "/srv/share/Movies:/movies"
      ];
    };
    sonarr = {
      enable = true;
      volumes = [
        "sonarr_data:/config"
        "/srv/share/Downloads:/downloads"
        "/srv/share/TV:/tv"
      ];
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
