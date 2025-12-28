{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.buby.programs.ashell = {
      enable = true;
      systemd.enable = true;

      settings = {
        log_level = "warn";
        outputs.Targets = ["eDP-1"];
        position = "Top";
        app_launcher_cmd = "walker";

        modules = {
          left = ["Workspaces"];
          center = ["WindowTitle"];
          right = ["SystemInfo" ["Tray" "Clock" "Privacy" "Settings"]];
        };

        workspaces.enable_workspace_filling = true;
        window_title.truncate_title_after_length = 100;

        settings = {
          lock_cmd = "playerctl --all-players pause; hyprlock &";
          audio_sinks_more_cmd = "pavucontrol -t 3";
          audio_sources_more_cmd = "pavucontrol -t 4";
          wifi_more_cmd = "nm-connection-editor";
          vpn_more_cmd = "nm-connection-editor";
          bluetooth_more_cmd = "blueberry";
        };

        appearance = {
          success_color = "#a6e3a1";
          text_color = "#cdd6f4";
          workspace_colors = ["#fab387" "#b4befe" "#cba6f7"];

          primary_color = {
            base = "#fab387";
            text = "#1e1e2e";
          };

          danger_color = {
            base = "#f38ba8";
            weak = "#f9e2af";
          };

          background_color = {
            base = "#1e1e2e";
            weak = "#313244";
            strong = "#45475a";
          };

          secondary_color = {
            base = "#11111b";
            strong = "#1b1b25";
          };
        };
      };
    };
  };
}
