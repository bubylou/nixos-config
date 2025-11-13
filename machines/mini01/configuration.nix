{...}: {
  imports = [./disk-config.nix ./hardware-configuration.nix];

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  system.stateVersion = "25.05";
}
