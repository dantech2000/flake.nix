{
  description = "D Rod's Darwin and NixOS system flake";

  inputs = {
    # Use a matching Nixpkgs release for macOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    # Darwin dependencies (must match the Nixpkgs release)
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Shared dependencies
    # Pin Home Manager to the corresponding release and follow the same Nixpkgs
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Spicetify dependencies
    #spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    #spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    inherit (flake-utils.lib) eachDefaultSystem;

    # User
    user = "drodriguez";

    # Shared configuration for both Darwin and NixOS
    sharedModules = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    };

    # Nixpkgs configuration
    nixpkgsConfig = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    # Function to create system-specific configurations

    # Function to create Darwin-specific configurations
    mkDarwinConfig = {
      system,
      hostname,
      user,
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs user hostname;};
        modules = [
          ./modules/nix-darwin
          {nixpkgs = nixpkgsConfig;}
          home-manager.darwinModules.home-manager
          (sharedModules
            // {
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

    # Function to create standalone home-manager configurations
    mkHomeManagerConfig = {
      system,
      hostname,
      user,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs user hostname;};
        modules = [
          {nixpkgs = nixpkgsConfig;}
          ./modules/home-manager
          {
            home.username = user;
            home.homeDirectory =
              if nixpkgs.legacyPackages.${system}.stdenv.isLinux
              then "/home/${user}"
              else "/Users/${user}";
          }
        ];
      };
    # Function to create NixOS-specific configurations
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
          nixVersions.git
          alejandra # Alternative Nix formatter
          statix # Nix linter
        ];
        shellHook = ''
          export SHELL=${nixpkgs.legacyPackages.${system}.zsh}/bin/zsh
          exec ${nixpkgs.legacyPackages.${system}.zsh}/bin/zsh
        '';
      };
    }))
    // {
      # Darwin Configurations
      darwinConfigurations = {
        "MAC-RNJMGYX0J5" = mkDarwinConfig {
          system = "arm64-darwin";
          hostname = "MAC-RNJMGYX0J5";
          user = user;
        };
      };

      # Home Manager Configurations (for non-NixOS Linux systems)
      homeConfigurations = {
        "serenity" = mkHomeManagerConfig {
          system = "x86_64-linux";
          hostname = "serenity";
          user = user;
        };
      };

      # Add packages output for compatibility
      packages.arm64-darwin.default = self.darwinConfigurations."MAC-RNJMGYX0J5".system;
      packages.x86_64-linux.default = self.homeConfigurations."serenity".activationPackage;
    };
}
