{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.headscale;
in {
  imports = [
    (import ./common/basic.nix {
      name = "headscale";
      port = 8080;
      inherit config lib;
    })
  ];

  options.home-lab.headscale = {
    nameservers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["1.1.1.1"];
      example = ["1.1.1.1" "9.9.9.9"];
    };

    tailnet = lib.mkOption {
      type = lib.types.str;
      default = "tailnet.${config.home-lab.domain}";
      example = "tailnet.example.com";
    };

    enableProxy = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      headscale = {
        enable = true;
        inherit (cfg) address;
        inherit (cfg) port;

        settings = {
          server_url = "https://${cfg.url}:${toString cfg.port}";
          dns = {
            base_domain = cfg.tailnet;
            nameservers.global = cfg.nameservers;
            search_domains = [cfg.tailnet config.home-lab.domain];
          };
          tls_letsencrypt_hostname = lib.mkIf (!cfg.enableProxy) cfg.url;
        };
      };
      caddy.virtualHosts."${cfg.url}" = {
        # no auth
        extraConfig = lib.mkIf cfg.enableProxy ''
          reverse_proxy http://${cfg.url}
        '';
      };
    };
  };
}
