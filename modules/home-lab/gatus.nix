{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.gatus;
in {
  imports = [
    (import ./common/basic.nix {
      name = "gatus";
      port = 8080;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    services = {
      gatus = {
        enable = true;

        settings = {
          web.port = cfg.port;
          endpoints = [];
        };
      };
    };
  };
}
