{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.jellyseerr;
in {
  imports = [
    (import ./common/basic.nix {
      name = "jellyseerr";
      port = 5055;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    services = {
      jellyseerr = {
        enable = true;
        inherit (cfg) port;
      };
    };
  };
}
