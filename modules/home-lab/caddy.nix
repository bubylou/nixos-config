{ pkgs, lib, config, ... }:
let
  cfg = config.home-lab.caddy;
in {
  options.home-lab.caddy = {
    enable = lib.mkEnableOption "enables caddy";

    machineName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the machine";
      default = config.networking.hostName;
      example = "nas02";
    };

    tailnetName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the tailnet";
      default = "";
      example = "test-example.ts.net";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;

      virtualHosts."https://${cfg.machineName}.${cfg.tailnetName}" = {
        extraConfig = ''
          respond "OK" 200
        '';
      };
    };

    # Allow the Caddy user(and service) to edit certs
    services.tailscale.permitCertUid = config.services.caddy.user;
  };
}
