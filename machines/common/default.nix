{config, ...}: {
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedTCPPorts = config.services.openssh.ports;
    allowedUDPPorts = [config.services.tailscale.port];
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = ["nix-command" "flakes"];
    settings.trusted-users = ["root" "@wheel"];
  };
}
