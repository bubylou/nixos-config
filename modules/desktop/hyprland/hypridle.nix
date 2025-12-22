{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  config = lib.mkIf cfg.enable {
    security.pam.services.hyprlock = {};
    home-manager.users.buby = {
      services.hypridle = {
        enable = true;
      };
      programs.hyprlock = {
        enable = true;
      };
    };
  };
}
