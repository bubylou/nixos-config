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
  };

  config = lib.mkIf (cfg.enable
    && config.home-lab.containerSupport) {
    virtualisation.oci-containers.containers = {
      radarr = {
        image = "ghcr.io/linuxserver/radarr:5.28.0";
        environment = {
          TZ = "America/New_York";
          RADARR__AUTH__ENABLED = "False";
          RADARR__AUTH__METHOD = "External";
          RADARR__AUTH__REQUIRED = "False";
        };
        ports = [
          "${toString cfg.port}:7878"
        ];
        volumes = [
          "radarr_data:/config"
        ];
      };
    };

    services.caddy = {
      virtualHosts."radarr.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          import auth
          reverse_proxy http://${cfg.host}:${toString cfg.port}
        '';
      };
    };

    services.gatus.settings.endpoints = [
      {
        name = "radarr";
        url = "http://${cfg.host}:${toString cfg.port}";
        interval = "1m";
        client.dns-resolver = "tcp://127.0.0.1:53";
        conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
      }
    ];
  };
}
