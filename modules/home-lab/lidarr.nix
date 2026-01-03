{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.lidarr;
in {
  imports = [
    (import ./common/arr.nix {
      name = "lidarr";
      port = 8686;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    users.users.lidarr.extraGroups = ["media"];

    services.lidarr = {
      enable = true;
      group = "media";
    };
  };
}
