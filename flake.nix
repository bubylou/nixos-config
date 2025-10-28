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
        imports = [
          ./machines/common/default.nix
          ./modules/home-lab/default.nix
          disko.nixosModules.disko
        ];
      };

      nas02 = { name, ... }: {
        deployment = {
          targetHost = name;
          targetUser = "buby";
          keys."acme-credentials.secret" = {
            keyFile = "/home/buby/Code/colmena/acme-credentials.secret";
            user = "acme";
          };
        };

        imports = [
          ./machines/${name}/disk-config.nix
          ./machines/${name}/hardware-configuration.nix
          ./machines/common/nvidia.nix
        ];

        networking.hostName = name;

        boot.supportedFilesystems = [ "nfs" ];
        fileSystems."/mnt/nfs/share" = {
          device = "nas01.bubylou.com:/srv/share";
          fsType = "nfs";
          options = [ "x-systemd.automount" "noauto" ];
        };
      };
    };
  };
}
