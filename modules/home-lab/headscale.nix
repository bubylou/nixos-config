{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.headscale;
in {
  options.home-lab.headscale = {
    enable = lib.mkEnableOption "enables headscale hub";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "headscale.${config.home-lab.domain}";
      example = "headscale.example.com";
    };

    tailnet = lib.mkOption {
      type = lib.types.str;
      default = "tailnet.${config.home-lab.domain}";
      example = "tailnet.example.com";
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
      headscale = {
        enable = true;
        inherit (cfg) address;
        inherit (cfg) port;

        settings = {
          dns = {
            base_domain = cfg.tailnet;
            nameservers.global = ["1.1.1.1"];
          };
        };
      };

      caddy = {
        virtualHosts."${cfg.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            reverse_proxy http://${cfg.address}:${toString cfg.port} {
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "headscale";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
