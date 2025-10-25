{ pkgs, lib, config, ... }:
let
  cfg = config.home-lab.blocky;
in {
  options.home-lab.blocky = {
    enable = lib.mkEnableOption "enables blocky";

    customDNS = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Custom DNS entries";
      example = { "nas01.localhost" = "192.168.1.11"; };
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 53;
    };
  };

  config = lib.mkIf cfg.enable {
    services.blocky = {
      enable = true;

      settings = {
        ports.dns = cfg.port;

        upstreams.groups.default = [
          "https://one.one.one.one/dns-query"
        ];

        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "1.1.1.1" "1.0.0.1" ];
        };

        blocking = {
          denylists = {
            ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          };

          clientGroupsBlock = {
            default = [ "ads" ];
          };
        };

        customDNS = {
          mapping = cfg.customDNS;
        };
      };
    };
  };
}
