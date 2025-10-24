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

  home-lab = {
    minecraft = {
      enable = true;
      operators = {
        Bubylou = "7fd923ac-5f25-456c-bc0b-48b0bed3bd40";
      };
      whitelist = {
        Bubylou = "7fd923ac-5f25-456c-bc0b-48b0bed3bd40";
      };
      package = pkgs.paperServers.paper-1_21_10;
    };
    
    caddy = {
      enable = true;
      tailnetName = "dhole-pirate.ts.net";
    };
  };

  system.stateVersion = "25.05";
}
