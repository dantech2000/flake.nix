{
  lib,
  pkgs,
  ...
}: {
  # CLI utilities and system tools
  home.packages = with pkgs;
    [
      # Core utilities (better versions)
      bat # Better cat with syntax highlighting
      eza # Better ls with icons and colors
      ripgrep # Better grep (faster, smarter)
      zoxide # Smart cd with frecency

      # System utilities
      coreutils-full # Core Unix utilities
      findutils # Find utilities
      gnugrep # GNU grep
      gnused # GNU sed
      htop # Interactive process viewer
      neofetch # System information
      time # Time command with detailed stats
      tree # Directory tree viewer

      # Network and connectivity
      curl # HTTP client
      wget # HTTP downloader
      dnsmasq # DNS forwarder
      sshpass # SSH password authentication

      # File processing and media
      ffmpeg_7 # Video/audio processing
      imagemagick # Image processing and conversion
      jq # JSON processor
      yq # YAML processor
      unzip # Archive extraction
      zlib # Compression library
      yt-dlp # Video downloader
      nil # Nix Language Server
      caligula # A lightweight, user-friendly disk imaging tool

      # Documentation and help
      tldr # Simplified man pages
      tmux # Terminal multiplexer

      # Security and encryption
      gnupg # GPG encryption

      # Fonts (for terminal display)
      jetbrains-mono # Programming font
      monaspace # Modern programming font

      # Image and data formats
      libheif # HEIF image format support
      libxslt # XML/XSLT processing

      # Example/test package
      hello # GNU Hello (example package)
    ]
    ++ lib.optionals stdenv.isLinux [
      # Linux-specific packages
      # Add any Linux-only CLI tools here when needed
    ]
    ++ lib.optionals stdenv.isDarwin [
      # macOS-specific packages (most Darwin apps come via Homebrew)
      # Add any macOS-only CLI tools here when needed
    ];
}
