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

        allowedUDPPorts = [
          config.services.tailscale.port
          8080 # kodi remote control
        ];
      };
    };

    users.extraUsers.kodi.isNormalUser = true;

    services.cage = {
      enable = true;
      program = "${pkgs.kodi-wayland}/bin/kodi";
      user = "kodi";
    };
  };
}
