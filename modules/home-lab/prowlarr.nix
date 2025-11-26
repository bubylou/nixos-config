{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.prowlarr;
in {
  options.home-lab.prowlarr = {
    enable = lib.mkEnableOption "enables prowlarr server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 9696;
      example = 9696;
    };
    volumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["prowlarr_data:/config"];
      example = ["prowlarr_data:/config"];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      prowlarr = {
        image = "ghcr.io/linuxserver/prowlarr:2.3.0";
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          GUID = "1000";
          PROWARR__AUTH__APIKEY_FILE = "/run/keys/prowlarr-apikey.secret";
          PROWARR__AUTH__ENABLED = "False";
          PROWARR__AUTH__METHOD = "External";
          PROWARR__AUTH__REQUIRED = "False";
        };
        ports = [
          "${toString cfg.port}:9696"
        ];
        inherit (cfg) volumes;
      };
    };

    services = {
      caddy = {
        virtualHosts."prowlarr.${config.home-lab.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.host}:${toString cfg.port}
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "prowlarr";
          url = "http://${cfg.host}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
