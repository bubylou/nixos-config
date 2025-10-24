{ pkgs, config, ... }:

{
  imports =
    [
      ../common/default.nix
      ../common/nvidia.nix
      ./disk-config.nix
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "nas02";

    interfaces.enp4s0 = {
      ipv4.addresses = [{
        address = "192.168.1.12";
        prefixLength = 24;
      }];
    };

    defaultGateway = {
      address = "192.168.1.254";
      interface = "enp4s0";
    };

    nameservers = [ "100.100.100.100" "1.1.1.1" ];

    firewall = {
      enable = true;
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers.paper = {
      enable = true;
      package = pkgs.paperServers.paper-1_21_10;

      serverProperties = {
        difficulty = 2;
        gamemode = 0;
      };
    };
  };

  system.stateVersion = "25.05";
}
