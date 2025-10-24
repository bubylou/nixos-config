{ pkgs, lib, config, ... }:
let
  cfg = config.home-lab.caddy;
in {
  options.home-lab.caddy = {
    enable = lib.mkEnableOption "enables caddy";

    machineName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the machine";
    };

    tailnetName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the tailnet";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts."${cfg.machineName}.${cfg.tailnetName}" = {
        extraConfig = ''
          respond "OK"
        '';
      };
    };

    # Allow the Caddy user(and service) to edit certs
    services.tailscale.permitCertUid = "caddy";
  };
}
