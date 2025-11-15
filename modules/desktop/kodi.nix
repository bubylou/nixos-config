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
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.kodi-gbm.withPackages
            (kodiPkgs:
              with kodiPkgs; [
                bluetooth-manager
                invidious
                jellyfin
                sendtokodi
                youtube
              ])}/bin/kodi-standalone";
          user = "kodi";
        };
      };
    };

    services.getty.autologinUser = "kodi";
    users.extraUsers.kodi.isNormalUser = true;
  };
}
