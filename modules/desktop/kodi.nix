{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.desktop.kodi;
in {
  options.desktop.kodi = {enable = lib.mkEnableOption "enables kodi kiosk";};

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;

      firewall = {
        # kodi remote control and event server
        allowedTCPPorts = [8080 9777];
        allowedUDPPorts = [8080 9777];
      };

      interfaces.enp1s0.wakeOnLan.enable = true;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        # auto login
        default_session = initial_session;
        initial_session = {
          command = "${pkgs.kodi-gbm.withPackages
            (kodiPkgs:
              with kodiPkgs; [
                bluetooth-manager
                jellyfin
                joystick
                keymap
                upnext
                youtube
              ])}/bin/kodi-standalone";
          user = "kodi";
        };
      };
    };

    users.extraUsers.kodi.isNormalUser = true;
    users.users.kodi.extraGroups = ["input" "video" "audio" "networkmanager"];
  };
}
