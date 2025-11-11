{pkgs, ...}: {
  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  desktop.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    prismlauncher
    qmk
    qmk-udev-rules
    wine
  ];
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
