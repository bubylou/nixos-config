{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.jellyseerr;
in {
  options.home-lab.jellyseerr = {
    enable = lib.mkEnableOption "enables jellyseerr server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 5055;
      example = 5055;
    };
  };

  config = lib.mkIf (cfg.enable
    && config.home-lab.containerSupport) {
    virtualisation.oci-containers.containers = {
      jellyseerr = {
        image = "ghcr.io/hotio/jellyseerr:release-2.7.3";
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          GUID = "1000";
        };
        ports = [
          "${toString cfg.port}:5055"
        ];
        volumes = [
          "jellyseerr_data:/config"
        ];
      };
    };

    services.caddy = {
      virtualHosts."jellyseerr.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          import auth
          reverse_proxy http://${cfg.host}:${toString cfg.port}
        '';
      };
    };

    services.gatus.settings.endpoints = [
      {
        name = "jellyseerr";
        url = "http://${cfg.host}:${toString cfg.port}";
        interval = "1m";
        client.dns-resolver = "tcp://127.0.0.1:53";
        conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
      }
    ];
  };
}
