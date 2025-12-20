{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.buby.services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "/home/buby/Pictures/wallpaper.png"
        ];

        wallpaper = [
          ", /home/buby/Pictures/wallpaper.png"
        ];
      };
    };
  };
}
