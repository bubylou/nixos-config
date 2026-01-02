{...}: {
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  desktop.kde.enable = true;

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };

  system.stateVersion = "25.05";
}
