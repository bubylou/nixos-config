{ lib, config, ... }:
let cfg = config.home-lab.blocky;
in
{
  options.home-lab.blocky = {
    enable = lib.mkEnableOption "enables blocky";

    adBlock = lib.mkEnableOption "enables ad blocking";

    customDNS = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Custom DNS entries";
      example = { "nas01.localhost" = "192.168.1.11"; };
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 53;
      description = "The port to listen on";
      example = 53;
    };
  };

  config = lib.mkIf cfg.enable {
    services.blocky = {
      enable = true;

      settings = {
        ports.dns = cfg.port;

        upstreams.groups.default = [ "https://one.one.one.one/dns-query" ];

        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "100.100.100.100" "1.1.1.1" ];
        };

        blocking = lib.mkIf cfg.adBlock {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
          };

          clientGroupsBlock = { default = [ "ads" ]; };
        };

        customDNS = { mapping = cfg.customDNS; };
      };
    };

    services.gatus.settings.endpoints = [{
      name = "blocky";
      url = "127.0.0.1:${toString cfg.port}";
      interval = "1m";
      dns = {
        query-name = "sugondeez.com";
        query-type = "A";
      };
      conditions = [ "[DNS_RCODE] == NOERROR" ];
    }];
  };
}
