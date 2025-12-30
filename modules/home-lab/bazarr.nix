{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.bazarr;

  basicOptions = name: port: {
    options.home-lab.${name} = {
      enable = lib.mkEnableOption "enables ${name} server";

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
  };

  basicConfig = name: {
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
in {
  imports = [
    (basicOptions "bazarr" 6767)
    (basicConfig "bazarr")
  ];

  config = lib.mkIf cfg.enable {
    services = {
      bazarr = {
        enable = true;
        listenPort = cfg.port;
      };
    };
  };
}
