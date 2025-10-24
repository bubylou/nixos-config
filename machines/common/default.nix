{ pkgs, lib, config, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://github.com/bubylou/nixos-config";
      branches.main.name = "main";
    }];
  };

  home-lab = {
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

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  nixpkgs.config.allowUnfree = true;
}
