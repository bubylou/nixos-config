{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  options.desktop.hyprland = {
    enable = lib.mkEnableOption "enables hyprland based desktop";
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    networking.networkmanager.enable = true;

    environment.systemPackages = with pkgs; [
      bluetui
      brave
      brightnessctl
      bitwarden-desktop
      cliphist
      discord
      firefox
      freetube
      fuzzel
      ghostty
      hypridle
      hyprlauncher
      hyprlock
      hyprpanel
      hyprpaper
      hyprpolkitagent
      hyprshot
      hyprpwcenter
      mpv
      rofi
      signal-desktop-bin
      tealdeer
      xdg-desktop-portal-hyprland
    ];
  };
}
