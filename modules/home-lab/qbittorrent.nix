{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.qbittorrent;
in {
  options.home-lab.qbittorrent = {
    enable = lib.mkEnableOption "enables qbittorrent server";

    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent.${config.home-lab.domain}";
      example = "example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      example = 443;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      qbittorrent = {
        enable = true;
        webuiPort = cfg.port;

        serverConfig = {
          LegalNotice.Accepted = true;
          Preferences = {
            WebUI = lib.mkIf (cfg.disableAuth) {
              HostHeaderValidation = true;
              ReverseProxySupportEnabled = true;
              ServerDomains = "*.bubylou.com";
            };
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
          name = "qbittorrent";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
