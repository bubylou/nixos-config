{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.radarr;
in {
  options.home-lab.radarr = {
    enable = lib.mkEnableOption "enables radarr server";

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [
        "/run/keys/radarr-apikey"
      ];
      example = [
        "/run/keys/radarr-4k-apikey"
        "/tmp/radarr-4k-config"
      ];
    };

    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "radarr.${config.home-lab.domain}";
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
      radarr = {
        enable = true;

        inherit (cfg) environmentFiles;

        settings = {
          server = {
            bindaddress = cfg.address;
            port = cfg.port;
          };

          auth = lib.mkIf (cfg.disableAuth) {
            enabled = false;
            method = "External";
            authenticationrequired = false;
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
          name = "radarr";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
