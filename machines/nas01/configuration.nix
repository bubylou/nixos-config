{config, ...}: let
  mini01 = "100.64.0.5";
  nas01 = "100.64.0.3";
  nas02 = "100.64.0.4";
  oracle01 = "129.80.110.240";
in {
  imports = [
    ../common/rclone.nix
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

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

    authelia = {
      enable = true;
      address = "0.0.0.0";
    };
    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };
    lldap = {
      enable = true;
      ldapAddress = "0.0.0.0";
      ldapBaseDN = "dc=bubylou,dc=com";
    };

    beszel-hub.enable = true;
    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/v5jX8oQ9lZzIgtX+b0BMJ6inyhZr/ta12w5Xs+mZg";
    };

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "bazarr.bubylou.com" = mini01;
        "headscale.bubylou.com" = oracle01;
        "jellyfin.bubylou.com" = nas02;
        "jellyseerr.bubylou.com" = nas02;
        "lidarr.bubylou.com" = nas02;
        "navidrome.bubylou.com" = nas02;
        "radarr-4k.bubylou.com" = mini01;
        "status.bubylou.com" = nas02;
        "bubylou.com" = nas01;
      };
    };

    glance = {
      enable = true;
      port = 8081;

      pages = [
        {
          name = "Startpage";
          hide-desktop-navigation = true;

          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  autofocus = true;
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = [
                    {
                      title = "Authelia";
                      url = "https://auth.bubylou.com/";
                      icon = "si:authelia";
                    }
                    {
                      title = "Jellyfin";
                      url = "https://jellyfin.bubylou.com/";
                      icon = "si:jellyfin";
                    }
                    {
                      title = "Jellyseerr";
                      url = "https://jellyseerr.bubylou.com/";
                      icon = "sh:jellyseerr";
                    }
                    {
                      title = "Radarr";
                      url = "https://radarr.bubylou.com/ping";
                      icon = "sh:radarr";
                    }
                    {
                      title = "Radarr 4k";
                      url = "https://radarr-4k.bubylou.com/ping";
                      allow-insecure = true;
                      icon = "sh:radarr";
                    }
                    {
                      title = "Sonarr";
                      url = "https://sonarr.bubylou.com/ping";
                      icon = "sh:sonarr";
                    }
                    {
                      title = "qBittorrent";
                      url = "https://qbittorrent.bubylou.com/api/v2/auth/login";
                      icon = "si:qbittorrent";
                      alt-status-codes = [405];
                    }
                  ];
                }
                {
                  type = "to-do";
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "rss";
                  title = "RSS";
                  feeds = [
                    {
                      title = "selfh.st";
                      url = "https://selfh.st/rss/";
                    }
                    {
                      title = "GamingOnLinux";
                      url = "https://www.gamingonlinux.com/article_rss.php";
                    }
                    {
                      title = "Noted";
                      url = "https://noted.lol/rss";
                    }
                  ];
                }
                {
                  type = "hacker-news";
                  title = "Hacker News";
                  limit = 15;
                  collapse-after = 5;
                }
              ];
            }
          ];
        }
      ];
    };

    qbittorrent = {
      enable = true;
      volumes = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
        "/srv/media/downloads:/downloads"
      ];
    };

    prowlarr = {
      enable = true;
      address = "0.0.0.0";
    };
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
