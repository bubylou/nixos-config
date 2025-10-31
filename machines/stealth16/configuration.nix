{pkgs, ...}: {
  imports = [./disk-config.nix ./hardware-configuration.nix ../common/nvidia.nix];

  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  desktop.gnome.enable = true;

  environment.systemPackages = with pkgs; [qmk qmk-udev-rules];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "buby";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
