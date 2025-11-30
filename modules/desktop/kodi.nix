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
        # kodi remote control
        allowedTCPPorts = [8080];
        allowedUDPPorts = [8080];
      };

      interfaces.enp1s0.wakeOnLan.enable = true;
    };

    services.greetd = {
      enable = true;
      settings = rec {
        default_session = initial_session;
        initial_session = {
          command = "${pkgs.kodi-gbm.withPackages
            (kodiPkgs:
              with kodiPkgs; [
                bluetooth-manager
                invidious
                jellyfin
                joystick
                keymap
                sendtokodi
                upnext
                youtube
              ])}/bin/kodi-standalone";
          user = "kodi";
        };
      };
    };

    users.extraUsers.kodi.isNormalUser = true;
  };
}
