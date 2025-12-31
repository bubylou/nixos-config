{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.lldap;
in {
  imports = [
    (import ./common/basic.nix {
      name = "lldap";
      port = 17170;
      inherit config lib;
    })
  ];

  options.home-lab.lldap = {
    ldapAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
    };

    ldapPort = lib.mkOption {
      type = lib.types.int;
      default = 3890;
      example = 389;
    };

    ldapBaseDN = lib.mkOption {
      type = lib.types.str;
      default = "dc=example,dc=com";
      example = "dc=testing,dc=net";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      lldap = {
        silenceForceUserPassResetWarning = true;

        settings = {
          ldap_user_email = "admin@${config.home-lab.domain}";
          ldap_user_dn = "admin";
          ldap_user_pass_file = "/etc/nixos/secrets/lldap-admin-password.secret";
          ldap_port = cfg.ldapPort;
          ldap_host = cfg.ldapAddress;
          ldap_base_dn = "${cfg.ldapBaseDN}";

          http_url = "https://${cfg.url}";
          http_port = cfg.port;
          http_host = cfg.address;

          database_url = "sqlite://./users.db?mode=rwc";
        };
      };
    };
  };
}
