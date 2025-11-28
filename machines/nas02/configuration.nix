{config, ...}: let
  nas01 = "100.93.143.35";
  nas02 = "100.78.117.28";
in {
  boot.supportedFilesystems = ["nfs"];
  fileSystems."/mnt/nfs/share" = {
    device = "nas01:/srv/share";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto"];
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
    lldap = {
      enable = false;
      ldapBaseDN = "dc=bubylou,dc=com";
      ldapHost = nas01;
    };

    blocky = {
      enable = true;
      adBlock = true;
      customDNS = {
        "bubylou.com" = nas01;
        "jellyfin.bubylou.com" = nas02;
        "jellyseerr.bubylou.com" = nas02;
        "status.bubylou.com" = nas02;
      };
    };

    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };

    gatus.enable = true;
    jellyfin = {
      enable = true;
      volumes = [
        "jellyfin_data:/config"
        "/mnt/nfs/share/Movies:/movies"
        "/mnt/nfs/share/TV:/tv"
      ];
    };
    jellyseerr.enable = true;

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking = {
    nameservers = ["::1"];

    firewall = {
      allowedTCPPorts = [
        443
        80
      ];
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
      ];
    };
  };

  system.stateVersion = "25.05";
}
