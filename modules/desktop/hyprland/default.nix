{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
  ];

  options.desktop.hyprland = {
    enable = lib.mkEnableOption "enables hyprland based desktop";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.buby = {
      services = {
        hyprpolkitagent.enable = true;
      };
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
      fuzzel
      gapless
      ghostty
      hyprmon
      hyprlauncher
      hyprshot
      hyprpwcenter
      mpv
      signal-desktop-bin
      tealdeer
      webcord
    ];
  };
}
