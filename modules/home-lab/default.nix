{ lib, ... }: {
  imports = [ ./blocky.nix ./caddy.nix ./jellyfin.nix ./lldap.nix ./ssh.nix ];

  options.home-lab = {
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The base domain for the home-lab";
      default = "example.com";
    };
  };
}
