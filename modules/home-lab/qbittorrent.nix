{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.qbittorrent;
in {
  options.home-lab.qbittorrent = {
    enable = lib.mkEnableOption "enables qbittorrent server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      example = 8080;
    };

    volumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
      ];
      example = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
        "/mnt/nfs:/downloads"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.qbittorrent = {
      image = "ghcr.io/hotio/qbittorrent:release-5.1.4";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        GUID = "1000";
        VPN_ENABLED = "True";
        VPN_CONFIG = "wg0";
      };
      ports = [
        "${toString cfg.port}:8080"
      ];
      inherit (cfg) volumes;
    };

    services = {
      caddy = {
        virtualHosts."qbittorrent.${config.home-lab.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.host}:${toString cfg.port}
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "qbittorrent";
          url = "http://${cfg.host}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
