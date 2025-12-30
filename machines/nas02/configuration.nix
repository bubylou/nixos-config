{config, ...}: let
  mini01 = "100.64.0.5";
  nas01 = "100.64.0.3";
  nas02 = "100.64.0.4";
  oracle01 = "129.80.110.240";
in {
  imports = [
    ../common/rclone.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia.open = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  home-lab = {
    domain = "bubylou.com";

    authelia.enable = true;

    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/v5jX8oQ9lZzIgtX+b0BMJ6inyhZr/ta12w5Xs+mZg";
    };

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "headscale.bubylou.com" = oracle01;
        "jellyfin.bubylou.com" = nas02;
        "jellyseerr.bubylou.com" = nas02;
        "radarr-4k.bubylou.com" = mini01;
        "status.bubylou.com" = nas02;
        "bubylou.com" = nas01;
      };
    };

    caddy = {
      enable = true;
      authHost = "nas01";
      email = "bubylou@pm.me";
    };

    gatus.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;

    lldap = {
      enable = false;
      ldapBaseDN = "dc=bubylou,dc=com";
      ldapHost = nas01;
    };

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking = {
    nameservers = ["127.0.0.1"];

    firewall = {
      allowedTCPPorts = [
        443
        config.services.blocky.settings.ports.dns
      ];
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
      ];
    };
  };

  system.stateVersion = "25.05";
}
