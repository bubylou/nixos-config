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
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      brave
      bitwarden-desktop
      discord
      firefox
      ghostty
      mpv
      signal-desktop-bin
    ];
  };
}
