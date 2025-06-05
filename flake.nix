{
  description = "D Rod's Darwin and NixOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Darwin dependencies
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS dependencies
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Shared dependencies
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nix-darwin, home-manager, nixpkgs, nixos-hardware, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

      # Shared configuration for both Darwin and NixOS
      sharedModules = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };

      # Nixpkgs configuration
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      # Function to create system-specific configurations
      mkSystemConfig = { system, hostname, user, extraModules ? [ ] }: {
        inherit system;
        specialArgs = { inherit inputs user hostname; };
        modules = [
          ./modules/shared/default.nix
          {
            nixpkgs = nixpkgsConfig;
            networking.hostName = hostname;
            users.users.${user} = {
              home = "/home/${user}";
              isNormalUser = true;
            };
          }
          home-manager.nixosModules.home-manager
          (sharedModules // {
            home-manager.users.${user} = {
              imports = [
                ./modules/home
                ./modules/neovim
              ];
            };
          })
        ] ++ extraModules;
      };

      # Function to create Darwin-specific configurations
      mkDarwinConfig = { system, hostname, user }: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs user hostname; };
        modules = [
          ./modules/nix-darwin
          { nixpkgs = nixpkgsConfig; }
          home-manager.darwinModules.home-manager
          (sharedModules // {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.${user} = {
                imports = [
                  ./modules/home-manager
                ];
              };
            };
          })
        ];
      };

      # Function to create NixOS-specific configurations
      mkNixosConfig = { system, hostname, user }: nixpkgs.lib.nixosSystem (
        mkSystemConfig {
          inherit system hostname user;
          extraModules = [
            ./modules/nixos/${hostname}.nix
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        }
      );
    in
    (eachDefaultSystem (system: {
      # Development shell and formatting tools
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          nixpkgs-fmt
          git
          nil # Nix LSP
          zsh
          # Additional development tools
          nixUnstable
          alejandra # Alternative Nix formatter
          statix # Nix linter
        ];
        shellHook = ''
          export SHELL=${nixpkgs.legacyPackages.${system}.zsh}/bin/zsh
          exec ${nixpkgs.legacyPackages.${system}.zsh}/bin/zsh
        '';
      };
    })) // {
      # Darwin Configurations
      darwinConfigurations = {
        "drodriguezs-MacBook-Pro" = mkDarwinConfig {
          system = "x86_64-darwin";
          hostname = "drodriguezs-MacBook-Pro";
          user = "drodriguez";
        };
        "MAC-RNJMGYX0J5" = mkDarwinConfig {
          system = "arm64-darwin";
          hostname = "MAC-RNJMGYX0J5";
          user = "drodriguez";
        };
      };

      # NixOS Configurations
      nixosConfigurations = {
        # Desktop Configuration (commented out until needed)
        # "nixos-desktop" = mkNixosConfig {
        #   system = "x86_64-linux";
        #   hostname = "nixos-desktop";
        #   user = "drodriguez";
        # };
      };

      # Add packages output for compatibility
      packages.x86_64-darwin.default = self.darwinConfigurations."drodriguezs-MacBook-Pro".system;
      packages.arm64-darwin.defualt = self.darwinConfigurations."MAC-RNJMGYX0J5".system;
    };
}
