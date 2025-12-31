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
    services.jellyfin.enable = true;

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
