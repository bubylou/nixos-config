{
  lib,
  config,
  ...
}: let
  cfg = config.home-lab.qbittorrent;
in {
  imports = [
    (import ./common/basic.nix {
      name = "qbittorrent";
      port = 8080;
      inherit config lib;
    })
  ];

  options.home-lab.qbittorrent = {
    volumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
      ];
      example = [
        "qbittorrent_data:/config"
        "/run/keys/wg0.conf:/config/wireguard/wg0.conf:ro"
        "/mnt/nfs:/downloads"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.qbittorrent = {
      image = "ghcr.io/hotio/qbittorrent:release-5.1.4";
      environment = {
        TZ = "America/New_York";
        PUID = "1000";
        GUID = "1000";
        VPN_ENABLED = "True";
        VPN_CONFIG = "wg0";
      };
      ports = [
        "${toString cfg.port}:8080"
      ];
      inherit (cfg) volumes;
    };
  };
}
