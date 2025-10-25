{ pkgs, lib, config, ... }:
let
  cfg = config.home-lab.jellyfin;
in {
  options.home-lab.jellyfin = {
    enable = lib.mkEnableOption "enables jellyfin";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
    };

    services.caddy = {
      virtualHosts."https://jellyfin.${cfg.tailnetName}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
      };
    };
  };
}
