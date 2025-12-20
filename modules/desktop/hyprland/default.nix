{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  imports = [
    ../common.nix
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
      brightnessctl
      cliphist
      hyprmon
      hyprlauncher
      hyprshot
      hyprpwcenter
      mpv
      webcord
    ];
  };
}
