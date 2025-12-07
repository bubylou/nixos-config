{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nvf,
    nixpkgs,
    nix-minecraft,
    home-manager,
    disko,
    colmena,
    ...
  }: {
    colmenaHive = colmena.lib.makeHive {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };

      defaults = {name, ...}: {
        deployment = {
          targetHost = name;
          targetUser = "buby";
        };

        imports = [
          ./machines/${name}/configuration.nix
          ./machines/${name}/disk-config.nix
          ./machines/${name}/hardware-configuration.nix
          ./machines/common/default.nix
          ./modules/home-lab/default.nix
          ./modules/desktop/default.nix
          disko.nixosModules.disko
          nix-minecraft.nixosModules.minecraft-servers
        ];

        networking.hostName = name;
      };

      mini01 = {...}: {};

      nas01 = {config, ...}: {
        deployment = {
          tags = ["server"];
          keys = {
            "acme-cloudflare-credentials.secret" = {
              keyFile = "/etc/nixos/secrets/acme-cloudflare-credentials.secret";
              user = "acme";
              group = "acme";
            };

            "authelia-jwt.secret" = {
              keyFile = "/etc/nixos/secrets/authelia-jwt.secret";
              user = config.services.authelia.instances.main.user;
              group = config.services.authelia.instances.main.group;
              permissions = "0440";
              destDir = "/etc/nixos/secrets";
            };

            "authelia-session.secret" = {
              keyFile = "/etc/nixos/secrets/authelia-session.secret";
              user = config.services.authelia.instances.main.user;
              group = config.services.authelia.instances.main.group;
              permissions = "0440";
              destDir = "/etc/nixos/secrets";
            };

            "authelia-storage.secret" = {
              keyFile = "/etc/nixos/secrets/authelia-storage.secret";
              user = config.services.authelia.instances.main.user;
              group = config.services.authelia.instances.main.group;
              permissions = "0440";
              destDir = "/etc/nixos/secrets";
            };

            "brevo-smtp-credentials.secret" = {
              keyFile = "/etc/nixos/secrets/brevo-smtp-credentials.secret";
              user = config.services.authelia.instances.main.user;
              group = config.services.authelia.instances.main.group;
              permissions = "0440";
              destDir = "/etc/nixos/secrets";
            };

            "lldap-admin-password" = {
              keyFile = "/etc/nixos/secrets/lldap-admin-password.secret";
              user = config.services.authelia.instances.main.user;
              group = config.services.authelia.instances.main.group;
              permissions = "0440";
            };

            "radarr-apikey.secret" = {
              keyFile = "/etc/nixos/secrets/radarr-apikey.secret";
            };

            "sonarr-apikey.secret" = {
              keyFile = "/etc/nixos/secrets/sonarr-apikey.secret";
            };

            "wg0.conf" = {
              keyFile = "/etc/nixos/secrets/wg0.conf";
            };
          };
        };
      };

      nas02 = {config, ...}: {
        deployment = {
          tags = ["server"];
          keys = {
            "acme-cloudflare-credentials.secret" = {
              keyFile = "/etc/nixos/secrets/acme-cloudflare-credentials.secret";
              user = "acme";
              group = "acme";
            };
          };
        };
        imports = [{nixpkgs.overlays = [inputs.nix-minecraft.overlay];}];
      };

      stealth16 = {...}: {
        deployment = {
          tags = ["laptop"];
          allowLocalDeployment = true;
        };

        imports = [
          home-manager.nixosModules.home-manager
          nvf.nixosModules.nvf
          ./machines/common/games.nix
          ./machines/common/neovim.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.buby = ./machines/common/home.nix;
            };
          }
        ];
      };

      xps13 = {...}: {
        deployment = {
          tags = ["laptop"];
          allowLocalDeployment = true;
        };
      };
    };
  };
}
