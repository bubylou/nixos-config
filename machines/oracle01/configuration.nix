{...}: {
  home-lab = {
    domain = "bubylou.com";

    beszel-agent = {
      enable = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/v5jX8oQ9lZzIgtX+b0BMJ6inyhZr/ta12w5Xs+mZg";
    };

    caddy = {
      enable = true;
      email = "bubylou@pm.me";
    };
    headscale = {
      enable = true;
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
