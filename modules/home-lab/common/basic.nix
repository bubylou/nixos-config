{
  name,
  port,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.${name};
in {
  options.home-lab.${name} = {
    enable = lib.mkEnableOption "enables ${name}";

    url = lib.mkOption {
      type = lib.types.str;
      default = "${name}.${config.home-lab.domain}";
      example = "example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = port;
      example = 443;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
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
          name = "${name}";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
