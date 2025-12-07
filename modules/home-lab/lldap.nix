{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.lldap;
in {
  options.home-lab.lldap = {
    enable = lib.mkEnableOption "enables lldap server";

    httpHost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    httpPort = lib.mkOption {
      type = lib.types.int;
      default = 17170;
      example = 17170;
    };

    ldapHost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    ldapPort = lib.mkOption {
      type = lib.types.int;
      default = 3890;
      example = 3890;
    };

    ldapBaseDN = lib.mkOption {
      type = lib.types.str;
      default = "dc=example,dc=com";
      example = "dc=example,dc=com";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      lldap = {
        enable = true;
        silenceForceUserPassResetWarning = true;

        settings = {
          ldap_user_email = "admin@${config.home-lab.domain}";
          ldap_user_dn = "admin";
          ldap_user_pass_file = "/etc/nixos/secrets/lldap-admin-password.secret";
          ldap_port = cfg.ldapPort;
          ldap_host = cfg.ldapHost;
          ldap_base_dn = "${cfg.ldapBaseDN}";

          http_url = "https://lldap.${config.home-lab.domain}";
          http_port = cfg.httpPort;
          http_host = cfg.httpHost;

          database_url = "sqlite://./users.db?mode=rwc";
        };
      };

      caddy = {
        virtualHosts."lldap.${config.home-lab.domain}" = {
          useACMEHost = config.home-lab.domain;
          extraConfig = ''
            import auth
            reverse_proxy http://${cfg.httpHost}:${toString cfg.httpPort}
          '';
        };
      };

      gatus.settings.endpoints = [
        {
          name = "lldap";
          url = "http://${cfg.httpHost}:${toString cfg.httpPort}";
          interval = "1m";
          client.dns-resolver = "tcp://127.0.0.1:53";
          conditions = ["[STATUS] == 200" "[RESPONSE_TIME] < 100"];
        }
      ];
    };
  };
}
