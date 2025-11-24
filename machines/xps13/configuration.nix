{...}: {
  home-lab = {
    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  desktop.kde.enable = true;

  system.stateVersion = "25.05";
}
