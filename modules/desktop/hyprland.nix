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
    home-manager.users.buby = {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          windowrule = [
            "suppressevent maximize, class:.*"
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
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
              "$mod, C, exec, killactive"
              "$mod, M, exec, exit"
              "$mod, E, exec, yazi"
              "$mod, V, exec, togglefloating"
              "$mod, R, exec, hyprlauncher"
              "$mod, P, exec, pseudo"
              "$mod, J, exec, togglesplit"

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

      programs = {
        hyprlock.enable = true;
        hyprpanel.enable = true;
      };
      services = {
        hypridle.enable = true;
        hyprpaper.enable = true;
      };
    };

    security.pam.services.hyprlock = {};
    programs.hyprland.enable = true;
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
      hyprlauncher
      hyprmon
      hyprpanel
      hyprpaper
      hyprpolkitagent
      hyprshot
      hyprpwcenter
      mpv
      signal-desktop-bin
      tealdeer
      webcord
      xdg-desktop-portal-hyprland
    ];
  };
}
