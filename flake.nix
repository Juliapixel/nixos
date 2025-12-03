{
  description = "My NixOS config";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    open_in_mpv.url = "github:Juliapixel/open_in_mpv";
    niri.url = "github:sodiboo/niri-flake";
    waybar.url = "github:Alexays/Waybar";
    stylix.url = "github:nix-community/stylix/release-25.11";
  };
  outputs = { self, home-manager, nixpkgs, open_in_mpv, niri, waybar, stylix }:
    {
      nixosConfigurations = {
        julia-nix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit open_in_mpv niri waybar stylix; };
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.default {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-bkp-${builtins.toString self.lastModified}";

                users.julia = {
                  imports = [
                    ./nixos/home.nix
                    stylix.homeModules.stylix
                    niri.homeModules.config
                    niri.homeModules.stylix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
