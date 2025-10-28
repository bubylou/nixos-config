{ pkgs, config, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    nameservers = [ "127.0.0.1" "100.100.100.100" "1.1.1.1" ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];

      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
        config.services.tailscale.port
      ];
    };
  };

  time.timeZone = "America/New_York";
  users.users.buby = {
    isNormalUser = true;
    description = "Nicholas Malcolm";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLpbx2wvIh7+iksunMRtHh9qDfwojF4j/ObtH+IdxMD buby@stealth16ai"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhoQaZW/NXiN5504yj83XwTB+lzgwmvKnMq2LMQyYh9 buby@xps13-9370"
    ];
  };

  home-lab = {
    blocky = {
      enable = true;
      adBlock = true;
      customDNS = { "bubylou.com" = "192.168.1.11"; };
    };

    caddy = {
      enable = true;
      domain = "sugondeez.com";
      email = "bubylou@pm.me";
    };

    ssh = {
      enable = true;
      users = [ "buby" ];
    };
  };

  services.tailscale.enable = true;

  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  environment.systemPackages = with pkgs; [ curl gitMinimal ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "buby" ];
  system.stateVersion = "25.05";
}
