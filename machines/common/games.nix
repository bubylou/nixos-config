{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bottles
    heroic
    mangohud
    prismlauncher
  ];

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };
}
