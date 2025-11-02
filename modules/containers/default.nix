{...}: {
  imports = [./jellyfin.nix];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # conflicts with blocky
      # defaultNetwork.settings.dns_enabled = true;
    };
  };
}
