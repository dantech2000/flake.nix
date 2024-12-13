{
  description = "D Rod's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs, ... }@inputs:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#drodriguezs-MacBook-Pr
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

        "zerocool" = nix-darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./modules/darwin/zerocools-MacBook-Pro.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zerocool = {
                imports = [
                  ./modules/home/home.nix
                  ./modules/neovim
                ];
              };
            }
          ];
        };
      };
    };
}
