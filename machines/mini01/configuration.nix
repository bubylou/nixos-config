{pkgs, ...}: {
  imports = [./disk-config.nix ./hardware-configuration.nix];

  desktop.kodi.enable = true;

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking.interfaces.wlp0s20f3.wakeOnLan.enable = true;

  system.stateVersion = "25.05";
}
