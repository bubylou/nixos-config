{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.kde;
in {
  options.desktop.kde = {
    enable = lib.mkEnableOption "enables kde desktop";
  };

  config = lib.mkIf cfg.enable {
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      krdp
      okular # pdf viewer
      plasma-browser-integration
    ];

    environment.systemPackages = with pkgs; [
      brave
      bitwarden-desktop
      discord
      firefox
      foliate
      ghostty
      onlyoffice-bin
      signal-desktop-bin
    ];

    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        sddm.enable = true;
        sddm.wayland.enable = true;
      };
    };
  };
}
