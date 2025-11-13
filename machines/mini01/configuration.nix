{pkgs, ...}: {
  imports = [./disk-config.nix ./hardware-configuration.nix];

  desktop.kodi.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  system.stateVersion = "25.05";
}
