{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.jellyfin;
in {
  imports = [
    (import ./common/basic.nix {
      name = "jellyfin";
      port = 8096;
      inherit config lib;
    })
  ];

  config = lib.mkIf cfg.enable {
    users.users.jellyfin.extraGroups = ["media"];

    services.jellyfin = {
      enable = true;
      group = "media";
    };

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
