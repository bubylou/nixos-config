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
        enable = true;
        trustedInterfaces = ["tailscale0"];

        allowedTCPPorts = [
          8080 # kodi remote control
        ];
        allowedUDPPorts = [
          config.services.tailscale.port
          8080 # kodi remote control
        ];
      };
    };

    services.cage = {
      enable = true;
      program = "${pkgs.kodi-wayland.withPackages
        (kodiPkgs:
          with kodiPkgs; [
            bluetooth-manager
            invidious
            jellyfin
            sendtokodi
            youtube
          ])}/bin/kodi";
      user = "kodi";
    };

    users.extraUsers.kodi.isNormalUser = true;
  };
}
