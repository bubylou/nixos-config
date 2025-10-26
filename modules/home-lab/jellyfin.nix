{ lib, config, ... }:
let cfg = config.home-lab.jellyfin;
in
{
  options.home-lab.jellyfin = {
    enable = lib.mkEnableOption "enables jellyfin";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Domain name of the jellyfin server";
      example = "localhost";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = { enable = true; };

    services.caddy = {
      virtualHosts."https://jellyfin.${cfg.domain}" = {
        extraConfig = ''
          bind tailscale/jellyfin
          tls {
            get_certificate tailscale
          }
          reverse_proxy 0.0.0.0:8096
        '';
      };
    };
  };
}
