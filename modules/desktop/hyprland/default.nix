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

      home.pointerCursor = {
        gtk.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      gtk = {
        enable = true;

        theme = {
          package = pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
        };

        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };

        font = {
          name = "Sans";
          size = 11;
        };
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
