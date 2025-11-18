{
  pkgs,
  config,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;
  time.timeZone = "America/New_York";
  users.users = {
    buby = {
      isNormalUser = true;
      description = "Nicholas Malcolm";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/e963EBACYLtFHUXnffAgEARmrALCpe4klwAaZ9UEA buby@stealth16ai"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZ9f7vpm92A7vER2PrwI9RKJlFcCbTx4Md0h/Dmxh1g buby@xps13"
      ];
    };

    terible = {
      isNormalUser = true;
      description = "Teri Malcolm";
      extraGroups = ["networkmanager"];
    };
  };

  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedTCPPorts = config.services.openssh.ports;
    allowedUDPPorts = [config.services.tailscale.port];
  };

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = ["root" "@wheel"];
}
