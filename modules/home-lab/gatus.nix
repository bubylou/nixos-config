{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.gatus;
in {
  options.home-lab.gatus = {
    enable = lib.mkEnableOption "enables gatus server";

    host = lib.mkOption {
      type = lib.types.str;
      description = "The host to use for the gatus server";
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      example = 8080;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      gatus = {
        enable = true;

        settings = {
          web.port = cfg.port;
          endpoints = [];
        };
      };

      caddy = {
        virtualHosts."status.${config.home-lab.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.host}:${toString cfg.port}
          '';
        };
      };
    };
  };
}
