{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.glance;
in {
  options.home-lab.glance = {
    enable = lib.mkEnableOption "enables glance server";

    url = lib.mkOption {
      type = lib.types.str;
      default = "glance.${config.home-lab.domain}";
      example = "example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 7878;
      example = 443;
    };

    pages = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [
        {
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "calendar";
                }
              ];
            }
          ];
          name = "Calendar";
        }
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      glance = {
        enable = true;

        settings = {
          inherit (cfg) pages;

          # catppuccin mocha
          theme = {
            background-color = "240 21 15";
            contrast-multiplier = 1.2;
            primary-color = "217 92 83";
            positive-color = "115 54 76";
            negative-color = "347 70 65";
          };

          server = {
            host = cfg.address;
            inherit (cfg) port;
          };
        };
      };

      caddy = {
        virtualHosts."${cfg.url}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.address}:${toString cfg.port}
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "glance";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
