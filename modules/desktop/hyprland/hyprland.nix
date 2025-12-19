{
  lib,
  config,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    home-manager.users.buby.wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          "workspace 1 silent,class:firefox"
          "workspace 1 silent,class:brave"
          "workspace 3 silent,class:discord"
          "workspace 3 silent,class:signal"
          "workspace 3 silent,class:WebCord"
          "workspace 4 silent,class:steam"
          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "workspace special silent, title:^(Firefox — Sharing Indicator)$"
          "float, title:^(.*Bitwarden Password Manager.*)$"
        ];
        exec-once = [
          "firefox"
          "signal-desktop"
          "webcord"
          "steam"
        ];
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };
        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };
        "$mod" = "SUPER";
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
        bind =
          [
            "$mod, Q, exec, ghostty"
            "$mod, C, killactive"
            "$mod, M, exec, exit"
            "$mod, E, exec, yazi"
            "$mod, F, fullscreen"
            "$mod, G, togglegroup"
            "$mod, V, togglefloating"
            "$mod, R, exec, hyprlauncher"
            "$mod, P, pseudo"
            "$mod, J, togglesplit"

            "$mod, PRINT, exec, hyprshot -m window"
            ", PRINT, exec, hyprshot -m output"
            "$shiftMod, PRINT, exec, hyprshot -m region"

            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"

            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (
                i: let
                  ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );
      };
    };
  };
}
