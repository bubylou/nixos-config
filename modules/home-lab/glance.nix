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
  };

  config = lib.mkIf cfg.enable {
    services = {
      glance = {
        enable = true;

        settings = {
          server = {
            host = cfg.address;
            port = cfg.port;
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
