{config, ...}: let
  mini01 = "100.64.0.5";
  nas01 = "100.64.0.4";
  nas02 = "100.64.0.3";
  oracle01 = "150.136.152.171";
in {
  imports = [
    ../common/rclone.nix
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia.open = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  home-lab = {
    domain = "bubylou.com";

    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGutSQFNWBBGZjbT/zzm0NJNdU9FU09J4G5isz73Iyer";
    };

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "headscale.bubylou.com" = oracle01;

        "bazarr.bubylou.com" = mini01;
        "radarr-4k.bubylou.com" = mini01;

        "authelia.bubylou.com" = nas01;
        "beszel.bubylou.com" = nas01;
        "glance.bubylou.com" = nas01;
        "lldap.bubylou.com" = nas01;
        "prowlarr.bubylou.com" = nas01;
        "qbittorrent.bubylou.com" = nas01;
        "radarr.bubylou.com" = nas01;
        "sonarr.bubylou.com" = nas01;

        "jellyfin.bubylou.com" = nas02;
        "jellyseerr.bubylou.com" = nas02;
        "lidarr.bubylou.com" = nas02;
        "navidrome.bubylou.com" = nas02;
        "status.bubylou.com" = nas02;
      };
    };

    caddy = {
      enable = true;
      authAddress = "nas01";
      email = "bubylou@pm.me";
    };

    gatus = {
      enable = true;
      url = "status.bubylou.com";
    };

    jellyfin.enable = true;
    jellyseerr.enable = true;
    lidarr.enable = true;
    navidrome.enable = true;

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking = {
    nameservers = ["127.0.0.1"];

    firewall = {
      allowedTCPPorts = [
        443
        config.services.blocky.settings.ports.dns
      ];
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
      ];
    };
  };

  system.stateVersion = "25.05";
}
