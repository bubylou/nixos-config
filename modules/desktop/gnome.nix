{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.gnome;
in {
  imports = [
    ./common.nix
  ];

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
      gnome-tweaks
      gnomeExtensions.appindicator
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
