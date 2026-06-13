{
  description = "My NixOS config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    open_in_mpv.url = "github:Juliapixel/open_in_mpv";
    technorino = {
      url = "git+https://github.com/2547techno/technorino?submodules=1";
    };
    make_it_braille = {
      url = "github:juliapixel/make_it_braille";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-stable.url = "github:niri-wm/niri/v26.04";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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
      niri,
      noctalia,
    }:
    let

      mkSystem =
        system:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              open_in_mpv
              technorino
              make_it_braille
              noctalia
              ;
          };
          modules = [
            ./common
            ./${system}/configuration.nix
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-bkp-${self.shortRev}";

                users.julia.imports = [
                  noctalia.homeModules.default
                  ./home-manager
                ];
              };
            }
            niri.nixosModules.niri
            {
              nixpkgs.overlays = [ niri.overlays.niri ];
            }
          ];
        };
      systems = map (s: {
        name = s;
        value = (mkSystem s);
      }) [ "laptop" "desktop" ];
    in
    {
      nixosConfigurations = builtins.listToAttrs systems;
    };
}
