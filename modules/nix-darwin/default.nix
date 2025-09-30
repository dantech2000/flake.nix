{...}: {
  # Complete modular nix-darwin configuration
  imports = [
    ./fonts # Fonts: Nix fonts installation
    ./security # Security: TouchID authentication
    ./users # Users: User account management
    ./system # System: macOS defaults and settings
    ./programs # Programs: System packages, ZSH, applications
    ./homebrew # Homebrew: Package management via Homebrew
    #    ./spicetify # Spicetify: Spotify customization
  ];
}
