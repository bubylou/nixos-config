{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.radarr;
in {
  imports = [
    (import ./common/arr.nix {
      name = "radarr";
      port = 7878;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    services.radarr.enable = true;
  };
}
