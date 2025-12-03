{
  description = "DRod's Darwin and NixOS system flake";

  inputs = {
    # Use nixpkgs unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Darwin dependencies (using master to track unstable)
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Shared dependencies
    # Use Home Manager master to track unstable nixpkgs
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Nixvim for declarative neovim configuration
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Spicetify dependencies
    #spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    #spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Sops-nix for secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    nixvim,
    flake-utils,
    sops-nix,
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
        allowBroken = true;
      };
    };

    # Function to create system-specific configurations

    # Function to create Darwin-specific configurations
    mkDarwinConfig = {
      system,
      hostname,
      user,
      extraModules ? [],
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs user hostname;};
        modules =
          [
            ./modules/nix-darwin
            {nixpkgs = nixpkgsConfig;}
            home-manager.darwinModules.home-manager
            (
              sharedModules
              // {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  users.${user} = {
                    imports = [
                      nixvim.homeModules.nixvim
                      sops-nix.homeModules.sops
                      ./modules/home-manager
                    ];
                  };
                };
              }
            )
          ]
          ++ extraModules;
      };

    # Function to create standalone home-manager configurations
    mkHomeManagerConfig = {
      system,
      hostname,
      user,
      extraModules ? [],
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs user hostname;};
        modules =
          [
            nixvim.homeModules.nixvim
            sops-nix.homeModules.sops
            {nixpkgs = nixpkgsConfig;}
            ./modules/home-manager
            {
              home.username = user;
              home.homeDirectory =
                if nixpkgs.legacyPackages.${system}.stdenv.isLinux
                then "/home/${user}"
                else "/Users/${user}";
            }
          ]
          ++ extraModules;
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
          inherit user;
          extraModules = [./hosts/MAC-RNJMGYX0J5];
        };
        "nebula" = mkDarwinConfig {
          system = "x86_64-darwin";
          hostname = "nebula";
          inherit user;
          extraModules = [./hosts/nebula];
        };
      };

      # Home Manager Configurations (for non-NixOS Linux systems)
      homeConfigurations = {
        "serenity" = mkHomeManagerConfig {
          system = "x86_64-linux";
          hostname = "serenity";
          inherit user;
          extraModules = [./hosts/serenity];
        };
      };

      # Add packages output for compatibility
      packages.arm64-darwin.default = self.darwinConfigurations."MAC-RNJMGYX0J5".system;
      packages.x86_64-linux.default = self.homeConfigurations."serenity".activationPackage;
    };
}
