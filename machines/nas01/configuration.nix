{config, ...}: let
  mini01 = "100.64.0.5";
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
        "radarr-4k.bubylou.com" = mini01;
        "status.bubylou.com" = nas02;
        "bubylou.com" = nas01;
      };
    };

    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };

    glance = {
      enable = true;
      port = 8081;

      pages = [
        {
          name = "Startpage";
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
                      title = "Jellyfin";
                      url = "https://jellyfin.bubylou.com/";
                      icon = "si:jellyfin";
                    }
                    {
                      title = "Jellyseerr";
                      url = "https://jellyseerr.bubylou.com/";
                      icon = "si:overseerr";
                    }
                    {
                      title = "Radarr";
                      url = "https://radarr.bubylou.com/ping";
                      icon = "si:radarr";
                    }
                    {
                      title = "Radarr 4k";
                      url = "https://radarr-4k.bubylou.com/ping";
                      icon = "si:radarr";
                    }
                    {
                      title = "Sonarr";
                      url = "https://sonarr.bubylou.com/ping";
                      icon = "si:sonarr";
                    }
                  ];
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
              ];
            }
          ];
        }
      ];
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
