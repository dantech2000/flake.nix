{
  description = "D Rod's Darwin and NixOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs, nixos-hardware, ... }@inputs:
    let
      mkDarwinConfig = { system, hostname, user }: nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./modules/darwin/${hostname}.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = {
              imports = [
                ./modules/home/home.nix
                ./modules/neovim
              ];
            };
          }
        ];
      };

      mkNixosConfig = { system, user }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = {
              imports = [
                ./modules/home/home.nix
                ./modules/neovim
              ];
            };
          }
        ];
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#drodriguezs-MacBook-Pro
      darwinConfigurations."drodriguezs-MacBook-Pro" = mkDarwinConfig {
        system = "x86_64-darwin";
        hostname = "drodriguezs-MacBook-Pro";
        user = "drodriguez";
      };

      # Build NixOS configuration using:
      # $ sudo nixos-rebuild switch --flake .#drod-nixos
      nixosConfigurations."drod-nixos" = mkNixosConfig {
        system = "x86_64-linux";
        user = "drodriguez";
      };
    };
}
