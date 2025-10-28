{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, colmena, ... }: {
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
        ];

        networking.hostName = name;
      };

      nas02 = { ... }: {
        deployment.keys = {
          "acme-credentials.secret" = {
            keyFile = "/home/buby/Code/colmena/acme-credentials.secret";
            user = "acme";
          };
        };
      };

      xps13 = { ... }: { };
    };
  };
}
