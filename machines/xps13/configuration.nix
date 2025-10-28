{ pkgs, ... }:

{
  imports = [ ./disk-config.nix ./hardware-configuration.nix ];

  home-lab = {
    ssh = {
      enable = true;
      users = [ "buby" ];
    };
  };

  desktop.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    gnome-characters
  ]);

  environment.systemPackages = with pkgs; [
    brave
    bitwarden-desktop
    discord
    firefox
    foliate
    ghostty
    obsidian
    onlyoffice-bin
    signal-desktop-bin
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
}
