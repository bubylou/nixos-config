{ lib, config, ... }:
let cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = {
    enable = lib.mkEnableOption "enables gnome desktop";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}
