{ user, ... }:

{
  # Core nix-darwin configuration for MAC-RNJMGYX0J5
  # All other functionality has been migrated to modular structure

  # Determinate Systems compatibility
  nix.enable = false;

  # Nix configuration for flakes
  nix.settings = {
    trusted-users = [ "root" user ];
    experimental-features = "nix-command flakes";
  };

  # Fix for nixbld group GID mismatch on macOS
  ids.gids.nixbld = 30000;

  # nix-darwin version for backwards compatibility  
  system.stateVersion = 5;

  # Platform specification for Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";
}
