{ lib, config, ... }:
let cfg = config.home-lab.caddy;
in
{
  options.home-lab.caddy = {
    enable = lib.mkEnableOption "enables caddy";

    email = lib.mkOption {
      type = lib.types.str;
      description = "The email address to use for ACME";
      default = "";
      example = "user@example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;

      globalConfig = ''
        auto_https off
        servers {
          trusted_proxies static private_ranges
        }
      '';

      extraConfig = ''
        (auth) {
          forward_auth :9091 {
            uri /api/authz/forward-auth
            copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          }
        }
      '';

      virtualHosts."${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          respond OK
        '';
      };
    };

    # Allow the Caddy user(and service) to edit certs
    services.tailscale.permitCertUid = config.services.caddy.user;

    security.acme = {
      acceptTerms = true;
      defaults.email = "${cfg.email}";

      certs."${config.home-lab.domain}" = {
        group = config.services.caddy.group;
        domain = "${config.home-lab.domain}";
        extraDomainNames = [ "*.${config.home-lab.domain}" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = "/run/keys/acme-cloudflare-credentials.secret";
      };
    };

    services.gatus.settings.endpoints = [{
      name = "caddy";
      url = "https://${config.home-lab.domain}";
      interval = "1m";
      client.dns-resolver = "tcp://127.0.0.1:53";
      conditions = [ "[STATUS] == 200" "[RESPONSE_TIME] < 100" "[BODY] == OK" ];
    }];
  };
}
