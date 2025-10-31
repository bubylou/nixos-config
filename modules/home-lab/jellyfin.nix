{ lib, config, ... }:
let cfg = config.home-lab.jellyfin;
in
{
  options.home-lab.jellyfin = {
    enable = lib.mkEnableOption "enables jellyfin";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = { enable = true; };

    services.caddy = {
      virtualHosts."jellyfin.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          reverse_proxy http://[::]:8096
        '';
      };
    };
  };
}
