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

      defaults = { pkgs, ... }: {
        imports = [ ./common.nix disko.nixosModules.disko ];
      };

      nas02 = { name, disko, ... }: {
        deployment = {
          targetHost = name;
          targetUser = "buby";
        };

        imports = [ ./disk-config.nix ./hardware-configuration.nix ];
        networking.hostName = name;
      };
    };
  };
}
