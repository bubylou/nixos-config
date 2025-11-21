{...}: {
  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  desktop.kde.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
