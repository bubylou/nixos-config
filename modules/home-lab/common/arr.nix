{
  name,
  port,
  config,
  lib,
  ...
}: let
  cfg = config.home-lab.${name};
in {
  imports = [
    (import ./basic.nix {
      inherit name port config lib;
    })
  ];

  options.home-lab.${name} = {
    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [
        "/run/keys/${name}-apikey"
      ];
      example = [
        "/run/keys/${name}-4k-apikey"
        "/tmp/${name}-4k-config"
      ];
    };

    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.${name} = {
      inherit (cfg) environmentFiles;

      settings = {
        server = {
          bindaddress = cfg.address;
          inherit (cfg) port;
        };

        auth = lib.mkIf cfg.disableAuth {
          enabled = false;
          method = "External";
          authenticationrequired = false;
        };
      };
    };
  };
}
