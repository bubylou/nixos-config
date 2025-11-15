{
  lib,
  config,
  ...
}: {
  imports = [
    ./authelia.nix
    ./blocky.nix
    ./caddy.nix
    ./gatus.nix
    ./jellyfin.nix
    ./lldap.nix
    ./minecraft.nix
    ./ssh.nix
  ];

  options.home-lab = {
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The base domain for the home-lab";
      default = "example.com";
    };

    containerSupport = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable container support";
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
