{user, ...}: {
  # Core nix-darwin configuration for nebula (Intel Mac)
  # All other functionality has been migrated to modular structure

  # Determinate Nix compatibility - disable nix-darwin's Nix management
  nix.enable = false;

  # Nix configuration for flakes (when using Determinate Nix)
  nix.settings = {
    trusted-users = ["root" user];
    experimental-features = "nix-command flakes";
  };

  # Fix for nixbld group GID mismatch on macOS
  ids.gids.nixbld = 30000;

  # nix-darwin state version (current for 2025)
  system.stateVersion = 6;

  # Primary user for nix-darwin v6 (required for user-specific options like homebrew, system defaults)
  system.primaryUser = user;

  # Platform specification for Intel Mac
  nixpkgs.hostPlatform = "x86_64-darwin";
}
