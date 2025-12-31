{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.radarr;
in {
  imports = [
    (import ./common/basic-options.nix {
      name = "radarr";
      port = 7878;
      inherit config lib;
    })
    (import ./common/basic-config.nix {
      name = "radarr";
      inherit config lib;
    })
  ];

  options.home-lab.radarr = {
    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [
        "/run/keys/radarr-apikey"
      ];
      example = [
        "/run/keys/radarr-4k-apikey"
        "/tmp/radarr-4k-config"
      ];
    };

    disableAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      radarr = {
        enable = true;

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
  };
}
