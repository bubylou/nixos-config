{...}: let
  mini01 = "100.64.0.5";
  nas01 = "100.64.0.4";
  nas02 = "100.64.0.3";
  oracle01 = "150.136.152.171";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  home-lab = {
    domain = "bubylou.com";

    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGutSQFNWBBGZjbT/zzm0NJNdU9FU09J4G5isz73Iyer";
    };

    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 443;
      nameservers = [nas01 nas02 "1.1.1.1" "9.9.9.9"];
    };

    ssh = {
      enable = true;
      users = ["buby"];
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [443];
      logRefusedConnections = false;
      rejectPackets = true;
    };
  };

  services = {
    cloud-init.enable = true;
  };

  system.stateVersion = "25.11";
}
