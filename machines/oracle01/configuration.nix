{...}: let
  nas01 = "100.64.0.3";
  nas02 = "100.64.0.4";
  oracle01 = "129.80.110.240";
in {
  home-lab = {
    domain = "bubylou.com";

    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/v5jX8oQ9lZzIgtX+b0BMJ6inyhZr/ta12w5Xs+mZg";
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
