{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.gnome;
in {
  options.desktop.gnome = {
    enable = lib.mkEnableOption "enables gnome desktop";
  };

  config = lib.mkIf cfg.enable {
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      gnome-characters
    ];

    environment.systemPackages = with pkgs; [
      brave
      bitwarden-desktop
      discord
      firefox
      foliate
      ghostty
      gnome-tweaks
      gnomeExtensions.appindicator
      obsidian
      onlyoffice-bin
      signal-desktop-bin
    ];

    networking.networkmanager.enable = true;

    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
    };
  };
}
