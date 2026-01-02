{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.sonarr;
in {
  imports = [
    (import ./common/arr.nix {
      name = "sonarr";
      port = 8989;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    users.users.sonarr.extraGroups = ["media"];

    services.sonarr = {
      enable = true;
      group = "media";
    };
  };
}
