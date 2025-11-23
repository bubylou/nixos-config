{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.sonarr;
in {
  options.home-lab.sonarr = {
    enable = lib.mkEnableOption "enables sonarr server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8989;
      example = 8989;
    };

    volumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["sonarr_data:/config"];
      example = ["sonarr_data:/config" "/mnt/nfs:/downloads"];
    };
  };

  config = lib.mkIf (cfg.enable
    && config.home-lab.containerSupport) {
    virtualisation.oci-containers.containers = {
      sonarr = {
        image = "ghcr.io/linuxserver/sonarr:4.0.16";
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          GUID = "1000";
          SONARR__AUTH__APIKEY_FILE = "/run/keys/sonarr-apikey.secret";
          SONARR__AUTH__ENABLED = "False";
          SONARR__AUTH__METHOD = "External";
          SONARR__AUTH__REQUIRED = "False";
        };
        ports = [
          "${toString cfg.port}:8989"
        ];
        volumes = cfg.volumes;
      };
    };

    services.caddy = {
      virtualHosts."sonarr.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          import auth
          reverse_proxy http://${cfg.host}:${toString cfg.port}
        '';
      };
    };

    services.gatus.settings.endpoints = [
      {
        name = "sonarr";
        url = "http://${cfg.host}:${toString cfg.port}";
        interval = "1m";
        client.dns-resolver = "tcp://127.0.0.1:53";
        conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
      }
    ];
  };
}
