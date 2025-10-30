{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nix-minecraft, disko, colmena, ... }: {
    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ ];
        };
      };

      defaults = { name, ... }: {
        deployment = {
          targetHost = name;
          targetUser = "buby";
        };

        imports = [
          ./machines/${name}/configuration.nix
          ./machines/common/default.nix
          ./modules/home-lab/default.nix
          ./modules/desktop/default.nix
          disko.nixosModules.disko
          nix-minecraft.nixosModules.minecraft-servers
        ];

        networking.hostName = name;
      };

      nas02 = { config, ... }: {
        deployment.keys = {
          "acme-cloudflare-credentials.secret" = {
            keyFile = "/etc/nixos/secrets/acme-cloudflare-credentials.secret";
            user = "acme";
            group = "acme";
          };

          "authelia-jwt.secret" = {
            keyFile = "/etc/nixos/secrets/authelia-jwt.secret";
            user = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
            permissions = "0644";
          };

          "authelia-session.secret" = {
            keyFile = "/etc/nixos/secrets/authelia-session.secret";
            user = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
            permissions = "0644";
          };

          "authelia-storage.secret" = {
            keyFile = "/etc/nixos/secrets/authelia-storage.secret";
            user = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
            permissions = "0644";
          };

          "brevo-smtp-credentials.secret" = {
            keyFile = "/etc/nixos/secrets/brevo-smtp-credentials.secret";
            user = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
            permissions = "0644";
          };

          "lldap-bind-credentials.secret" = {
            keyFile = "/etc/nixos/secrets/lldap-bind-credentials.secret";
            user = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
            permissions = "0644";
          };
        };
        imports = [{ nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }];
      };

      xps13 = { ... }: { };
    };
  };
}
