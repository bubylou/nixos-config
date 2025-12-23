{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.jellyseerr;
in {
  options.home-lab.jellyseerr = {
    enable = lib.mkEnableOption "enables jellyseerr server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "jellyseerr.${config.home-lab.domain}";
      example = "jellyseerr.example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 5055;
      example = 443;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      jellyseerr = {
        enable = true;
        inherit (cfg) port;
      };

      caddy = {
        virtualHosts."${cfg.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.address}:${toString cfg.port}
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "jellyseerr";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
