{ lib, config, ... }:
let cfg = config.home-lab.caddy;
in
{
  options.home-lab.caddy = {
    enable = lib.mkEnableOption "enables caddy";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "The base domain for caddy";
      default = "";
      example = "example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;

      virtualHosts."https://${config.networking.hostName}.${cfg.domain}" = {
        extraConfig = ''
          respond OK
        '';
      };
    };

    # Allow the Caddy user(and service) to edit certs
    services.tailscale.permitCertUid = config.services.caddy.user;
  };
}
