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
        settings = {
          general = {
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            lock_cmd = "pidof hyprlock || hyprlock";
          };

          listener = [
            {
              timeout = 180;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 1200;
              on-timeout = "sysemctl suspend";
            }
          ];
        };
      };
      programs.hyprlock = {
        enable = true;
      };
    };
  };
}
