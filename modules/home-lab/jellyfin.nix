{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.jellyfin;
in {
  options.home-lab.jellyfin = {
    enable = lib.mkEnableOption "enables jellyfin server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.${config.home-lab.domain}";
      example = "jellyfin.example.com";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8096;
      example = 443;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
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
          name = "jellyfin";
          url = "http://${cfg.address}:${toString cfg.port}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
