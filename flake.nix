{
  description = "My NixOS config";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };
  outputs = { self, home-manager, nixpkgs }:
    {
      nixosConfigurations = {
        julia-nix = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.default {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-bkp-${builtins.toString self.lastModified}";

                users.julia = ./nixos/home.nix;
              };
            }
          ];
        };
      };
    };
}
