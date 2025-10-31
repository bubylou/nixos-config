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
          reverse_proxy http://127.0.0.1:8096
        '';
      };
    };

    services.gatus.settings.endpoints = [{
      name = "jellyfin";
      url = "http://127.0.0.1:8096";
      interval = "1m";
      client.dns-resolver = "tcp://127.0.0.1:53";
      conditions = [ "[STATUS] == 200" "[RESPONSE_TIME] < 100" ];
    }];
  };
}
