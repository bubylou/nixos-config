{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.prowlarr;
in {
  imports = [
    ./prowlarr-script.nix
  ];

  options.home-lab.prowlarr = {
    enable = lib.mkEnableOption "enables prowlarr server";

    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "prowlarr.${config.home-lab.domain}";
      example = "example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 9696;
      example = 443;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      prowlarr = {
        enable = true;

        environmentFiles = [
          "/run/keys/prowlarr-apikey"
          "/run/keys/radarr-apikey"
          "/run/keys/sonarr-apikey"
        ];

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
          name = "prowlarr";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
