{...}: {
  imports = [./disk-config.nix ./hardware-configuration.nix];

  desktop.kodi.enable = true;

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  system.stateVersion = "25.05";
}
