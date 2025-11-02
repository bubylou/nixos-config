{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.containers.jellyfin;
in {
  options.home-lab.containers.jellyfin = {
    enable = lib.mkEnableOption "enables jellyfin";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8096;
      description = "Port to expose jellyfin on";
      example = 8096;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "ghcr.io/hotio/jellyfin:release-10.11.1";
        extraOptions = ["--device" "nvidia.com/gpu=all"];
        environment = {TZ = config.time.timeZone;};
        ports = ["127.0.0.1:${toString cfg.port}:8096"];
        volumes = [
          "jellyfin-config:/config"
          "/mnt/nfs/share/Movies:/data/movies"
          "/mnt/nfs/share/TV:/data/tv"
        ];
      };
    };

    services.caddy = {
      virtualHosts."jellyfin-test.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          reverse_proxy http://127.0.0.1:${toString cfg.port}
        '';
      };
    };
  };
}
