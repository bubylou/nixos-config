{
  lib,
  config,
  ...
}: {
  imports = [
    ./authelia.nix
    ./bazarr.nix
    ./beszel-agent.nix
    ./beszel-hub.nix
    ./blocky.nix
    ./caddy.nix
    ./gatus.nix
    ./glance.nix
    ./headscale.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./lldap.nix
    ./minecraft.nix
    ./prowlarr.nix
    ./qbittorrent.nix
    ./radarr.nix
    ./sonarr.nix
    ./ssh.nix
  ];

  options.home-lab = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "example.com";
    };

    containerSupport = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf config.home-lab.containerSupport {
    virtualisation = {
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerSocket.enable = true;
      };
    };
  };
}
