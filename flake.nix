{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, comin, disko, nix-minecraft, ... }: {
    nixosConfigurations = {
      nas02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          comin.nixosModules.comin
          disko.nixosModules.disko
          nix-minecraft.nixosModules.minecraft-servers
          ./machines/nas02/configuration.nix
          ./modules/home-lab/default.nix
          { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
        ];
      };
    };
  };
}
