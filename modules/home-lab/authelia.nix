{ lib, config, ... }:
let cfg = config.home-lab.authelia;
in
{
  options.home-lab.authelia = {
    enable = lib.mkEnableOption "enables authelia server";

    host = lib.mkOption {
      type = lib.types.str;
      description = "The host to use for the authelia server";
      default = "::";
      example = "::";
    };

    port = lib.mkOption {
      type = lib.types.int;
      description = "The port to use for the authelia server";
      default = 9091;
      example = 9091;
    };
  };

  config = lib.mkIf cfg.enable {
    services.authelia.instances.main = {
      enable = true;

      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          "/etc/nixos/secrets/lldap-bind-credentials.secret";
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE =
          "/etc/nixos/secrets/brevo-smtp-credentials.secret";
      };

      secrets = {
        jwtSecretFile = "/etc/nixos/secrets/authelia-jwt.secret";
        storageEncryptionKeyFile = "/etc/nixos/secrets/authelia-storage.secret";
        sessionSecretFile = "/etc/nixos/secrets/authelia-session.secret";
      };

      settings = {
        theme = "dark";
        log.level = "info";

        server = {
          address = "tcp://:${toString cfg.port}";
          endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };

        default_2fa_method = "webauthn";
        webauthn = {
          display_name = "${config.home-lab.domain}";
          enable_passkey_login = true;
          timeout = 60;
        };

        totp = {
          issuer = "${config.home-lab.domain}";
          algorithm = "SHA512";
          digits = 8;
          period = 60;
        };

        authentication_backend = {
          ldap = {
            implementation = "lldap";
            address = "ldap://[${config.home-lab.lldap.ldapHost}]:${
                toString config.home-lab.lldap.ldapPort
              }";
            base_dn = config.home-lab.lldap.ldapBaseDN;
            user = "uid=authelia_bind_user,ou=people,${
                toString config.home-lab.lldap.ldapBaseDN
              }";
            additional_users_dn = "ou=people";
            # allow username OR email login
            users_filter =
              "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";
          };
        };

        password_policy.zxcvbn = {
          enabled = true;
          min_score = 3;
        };

        definitions = {
          network = {
            internal = [ "192.168.1.0/24" "172.16.0.0/12" "10.80.0.0/16" ];
          };
        };

        access_control = {
          default_policy = "two_factor";
          rules = [
            {
              domain_regex = "(jellyfin|status).${config.home-lab.domain}$";
              policy = "bypass";
            }
            {
              domain_regex = "(jellyseerr|mealie).${config.home-lab.domain}$";
              policy = "one_factor";
            }
          ];
        };

        session = {
          name = "authelia_session";
          expiration = "1 hour";
          inactivity = "5 minutes";
          remember_me = "1 month";

          cookies = [{
            domain = "${config.home-lab.domain}";
            authelia_url = "https://auth.${config.home-lab.domain}";
            default_redirection_url =
              "https://jellyfin.${config.home-lab.domain}";
          }];

          redis.host = "/run/redis-authelia-main/redis.sock";
        };

        regulation = {
          max_retries = 3;
          find_time = "5m";
          ban_time = "15m";
        };

        storage = { local = { path = "/var/lib/authelia-main/db.sqlite3"; }; };

        notifier = {
          disable_startup_check = false;
          smtp = {
            address = "smtp://smtp-relay.brevo.com:587";
            timeout = "5 seconds";
            username = "6303af003@smtp-brevo.com";
            sender = "No Reply <no-reply@${config.home-lab.domain}>";
            identifier = "${config.home-lab.domain}";
            subject = "[Authelia] {title}";
            startup_check_address = "test@${config.home-lab.domain}";
            disable_require_tls = false;
            disable_html_emails = false;
            tls = {
              server_name = "smtp-relay.brevo.com";
              skip_verify = false;
              minimum_version = "TLS1.2";
              maximum_version = "TLS1.3";
            };
          };
        };
      };
    };

    users.users.authelia-main.extraGroups = [ "authelia-main" ];

    services.redis.servers.authelia-main = {
      enable = true;
      user = "authelia-main";
      port = 0;
      unixSocket = "/run/redis-authelia-main/redis.sock";
      unixSocketPerm = 600;
    };

    services.caddy = {
      virtualHosts."auth.${config.home-lab.domain}" = {
        useACMEHost = "${config.home-lab.domain}";
        extraConfig = ''
          reverse_proxy http://[${cfg.host}]:${toString cfg.port}
        '';
      };
    };
  };
}
