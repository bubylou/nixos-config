{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.beszel-hub;
in {
  options.home-lab.beszel-hub = {
    enable = lib.mkEnableOption "enables beszel hub";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8090;
      example = 8090;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      beszel.hub = {
        enable = true;
        environment = {
          APP_URL = "https://beszel.${config.home-lab.domain}";
          AUTO_LOGIN = "bubylou@pm.me";
          CONTAINER_DETAILS = "true";
        };
        inherit (cfg) host;
        inherit (cfg) port;
      };

      caddy = {
        virtualHosts."beszel.${config.home-lab.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth

            request_body {
              max_size 10MB
            }

            reverse_proxy http://${cfg.host}:${toString cfg.port} {
              transport http {
                read_timeout 360s
              }
            }
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "beszel";
          url = "http://${cfg.host}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
