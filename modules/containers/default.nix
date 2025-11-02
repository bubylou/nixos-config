{
  lib,
  config,
  ...
}: {
  imports = [./beszel.nix ./jellyfin.nix];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune.enable = true;

      # conflicts with blocky
      defaultNetwork.settings.dns_enabled = lib.mkIf config.home-lab.blocky.enable false;
    };
  };
}
