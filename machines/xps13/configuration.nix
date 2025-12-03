{pkgs, ...}: {
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
    graphics.extraPackages = with pkgs; [
      intel-media-sdk
    ];
  };

  system.stateVersion = "25.05";
}
