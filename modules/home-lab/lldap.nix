{ lib, config, ... }:
let cfg = config.home-lab.lldap;
in
{
  options.home-lab.lldap = {
    enable = lib.mkEnableOption "enables lldap server";

    httpHost = lib.mkOption {
      type = lib.types.str;
      description = "The host to use for the HTTP server";
      default = "::1";
      example = "::1";
    };

    httpPort = lib.mkOption {
      type = lib.types.int;
      description = "The port to use for the HTTP server";
      default = 17170;
      example = 17170;
    };

    ldapHost = lib.mkOption {
      type = lib.types.str;
      description = "The host to use for the LDAP server";
      default = "::";
      example = "::";
    };

    ldapPort = lib.mkOption {
      type = lib.types.int;
      description = "The port to use for the LDAP server";
      default = 3890;
      example = 3890;
    };

    ldapBaseDN = lib.mkOption {
      type = lib.types.str;
      description = "The base DN to use for the LDAP server";
      default = "dc=example,dc=com";
      example = "dc=example,dc=com";
    };
  };

  config = lib.mkIf cfg.enable {
    services.lldap = {
      enable = true;

      settings = {
        ldap_user_email = "admin@${config.home-lab.domain}";
        ldap_user_dn = "admin";
        ldap_port = cfg.ldapPort;
        ldap_host = cfg.ldapHost;
        ldap_base_dn = "${cfg.ldapBaseDN}";

        http_url = "https://lldap.${config.home-lab.domain}";
        http_port = cfg.httpPort;
        http_host = cfg.httpHost;

        database_url = "sqlite://./users.db?mode=rwc";
      };
    };

    services.caddy = {
      virtualHosts."lldap.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          import auth
          reverse_proxy http://${cfg.httpHost}:${toString cfg.httpPort}
        '';
      };
    };

    services.gatus.settings.endpoints = [{
      name = "lldap";
      url = "http://${cfg.httpHost}:${toString cfg.httpPort}";
      interval = "1m";
      client.dns-resolver = "tcp://127.0.0.1:53";
      conditions = [ "[STATUS] == 200" "[RESPONSE_TIME] < 100" ];
    }];
  };
}
