{...}: {
  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  desktop.gnome.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
