{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.jellyfin;
in {
  options.home-lab.jellyfin = {
    enable = lib.mkEnableOption "enables jellyfin server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8096;
      example = 8096;
    };
  };

  config = lib.mkIf (cfg.enable
    && config.home-lab.containerSupport) {
    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "ghcr.io/linuxserver/jellyfin:10.11.3";
        extraOptions = ["--device" "nvidia.com/gpu=all"];
        environment = {
          TZ = "America/New_York";
          PUID = "1000";
          GUID = "1000";
        };
        ports = [
          "${toString cfg.port}:8096"
        ];
        volumes = [
          "jellyfin_data:/config"
          "/mnt/nfs/share/Movies:/data/movies"
          "/mnt/nfs/share/TV:/data/tv"
        ];
      };
    };

    services.caddy = {
      virtualHosts."jellyfin.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          import auth
          reverse_proxy http://${cfg.host}:${toString cfg.port}
        '';
      };
    };

    services.gatus.settings.endpoints = [
      {
        name = "jellyfin";
        url = "http://${cfg.host}:${toString cfg.port}";
        interval = "1m";
        client.dns-resolver = "tcp://127.0.0.1:53";
        conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
      }
    ];
  };
}
