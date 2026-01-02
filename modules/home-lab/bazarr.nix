{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.bazarr;
in {
  imports = [
    (import ./common/basic.nix {
      name = "bazarr";
      port = 6767;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    users.users.bazarr.extraGroups = ["media"];
    services = {
      bazarr = {
        enable = true;
        listenPort = cfg.port;
        group = "media";
      };
    };
  };
}
