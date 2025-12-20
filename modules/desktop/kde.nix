{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.kde;
in {
  imports = [
    ./common.nix
  ];

  options.desktop.kde = {
    enable = lib.mkEnableOption "enables kde desktop";
  };

  config = lib.mkIf cfg.enable {
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      krdp
      plasma-browser-integration
    ];

    networking.networkmanager.enable = true;

    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm.enable = true;
        sddm.wayland.enable = true;
      };
    };
  };
}
