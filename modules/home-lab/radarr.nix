{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.radarr;
in {
  options.home-lab.radarr = {
    enable = lib.mkEnableOption "enables radarr server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 7878;
      example = 7878;
    };

    volumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["radarr_data:/config"];
      example = ["radarr_data:/config" "/mnt/nfs:/downloads"];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.radarr = {
      image = "ghcr.io/linuxserver/radarr:5.28.0";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        GUID = "1000";
        RADARR__AUTH__APIKEY_FILE = "/run/keys/radarr-apikey.secret";
        RADARR__AUTH__ENABLED = "False";
        RADARR__AUTH__METHOD = "External";
        RADARR__AUTH__REQUIRED = "False";
      };
      ports = [
        "${toString cfg.port}:7878"
      ];
      inherit (cfg) volumes;
    };

    services = {
      caddy = {
        virtualHosts."radarr.${config.home-lab.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.host}:${toString cfg.port}
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "radarr";
          url = "http://${cfg.host}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
