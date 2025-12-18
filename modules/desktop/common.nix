{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brave
    bitwarden-desktop
    discord
    firefox
    fuzzel
    gapless
    ghostty
    signal-desktop-bin
  ];
}
