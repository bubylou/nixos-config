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
    };

    # Allow the Caddy user(and service) to edit certs
    services.tailscale.permitCertUid = config.services.caddy.user;

    security.acme = {
      acceptTerms = true;
      defaults.email = "${cfg.email}";

      certs."${cfg.domain}" = {
        group = config.services.caddy.group;
        domain = "${cfg.domain}";
        extraDomainNames = [ "*.${cfg.domain}" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = "/run/keys/acme-credentials.secret";
      };
    };
  };
}
