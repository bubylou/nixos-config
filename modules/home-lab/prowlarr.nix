{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.prowlarr;
in {
  imports = [
    (import ./common/arr.nix {
      name = "prowlarr";
      port = 9696;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    services.prowlarr.enable = true;
  };
}
