{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.beszel-hub;
in {
  imports = [
    (import ./common/basic.nix {
      name = "beszel-hub";
      port = 8090;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    services = {
      beszel.hub = {
        enable = true;
        host = cfg.address;
        inherit (cfg) port;

        environment = {
          APP_URL = "https://${cfg.url}";
          AUTO_LOGIN = "bubylou@pm.me";
          CONTAINER_DETAILS = "true";
        };
      };

      caddy = {
        virtualHosts."beszel.${config.home-lab.domain}" = {
          extraConfig = ''
            request_body {
              max_size 10MB
            }

            reverse_proxy http://${cfg.address}:${toString cfg.port} {
              transport http {
                read_timeout 360s
              }
            }
          '';
        };
      };
    };
  };
}
