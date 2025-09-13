# This file contains shared configuration that applies to both Darwin and NixOS systems
{pkgs, ...}: {
  # Common system-level packages
  environment.systemPackages = with pkgs; [
    # Basic utilities
    curl
    wget
    git
    vim
    htop

    # Development tools
    gnumake
    gcc
  ];

  # Common system settings
  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = ["nix-command" "flakes"];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Add any other shared configuration here
}
