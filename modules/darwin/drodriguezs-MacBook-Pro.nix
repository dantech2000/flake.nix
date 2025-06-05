{ user, ... }:

{
  # Core nix-darwin configuration for drodriguezs-MacBook-Pro
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

  # Platform specification for Intel Mac
  nixpkgs.hostPlatform = "x86_64-darwin";
}
