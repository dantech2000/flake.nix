{
  description = "D Rod's Darwin and NixOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs, nixos-hardware, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

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
    (eachDefaultSystem (system: {
      # Per-system attributes can be defined here
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          nixpkgs-fmt
          git
          nil # Nix LSP
          zsh
        ];
        shellHook = ''
          export SHELL=${nixpkgs.legacyPackages.${system}.zsh}/bin/zsh
          exec ${nixpkgs.legacyPackages.${system}.zsh}/bin/zsh
        '';
      };
    })) // {
      # Your existing configurations
      darwinConfigurations."drodriguezs-MacBook-Pro" = mkDarwinConfig {
        system = "x86_64-darwin";
        hostname = "drodriguezs-MacBook-Pro";
        user = "drodriguez";
      };

      nixosConfigurations."drod-nixos" = mkNixosConfig {
        system = "x86_64-linux";
        user = "drodriguez";
      };

      nixosConfigurations."drod-wsl" = mkNixosConfig {
        system = "x86_64-linux";
        user = "drodriguez";
      };
    };
}
