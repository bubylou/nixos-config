{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, comin, disko }: {
    nixosConfigurations = {
      nas02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          comin.nixosModules.comin
          disko.nixosModules.disko
          ./machines/nas02/configuration.nix
          ./modules/home-lab/default.nix
        ];
      };
    };
  };
}
