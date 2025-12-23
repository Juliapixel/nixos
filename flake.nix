{
  description = "My NixOS config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    open_in_mpv.url = "github:Juliapixel/open_in_mpv";
    technorino = {
      url = "git+https://github.com/2547techno/technorino?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    make_it_braille = {
      url = "github:juliapixel/make_it_braille";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      open_in_mpv,
      technorino,
      make_it_braille,
    }:
    {
      nixosConfigurations = {
        julia-nix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit open_in_mpv technorino make_it_braille; };
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.default
            {
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
