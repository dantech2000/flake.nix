{
  description = "D Rod's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }: {

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#drodriguezs-MacBook-Pro

    darwinConfigurations = {
      "drodriguezs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./modules/darwin/drodriguezs-MacBook-Pro.nix
          home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.drodriguez = {
                imports = [ 
                  ./modules/home/home.nix
                  ./modules/neovim
                ];
              };
            }
        ];
      };
    };
    # Optionally, use home-manager.extraSpecialArgs to pass
    # arguments to home.nix
    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."drodriguezs-MacBook-Pro".pkgs;
  };
}
