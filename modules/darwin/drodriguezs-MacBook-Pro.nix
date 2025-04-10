{ self, pkgs, config, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.starship
      pkgs.mkalias
      pkgs.nixpkgs-fmt
      pkgs.nodejs
    ];

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;

  # Necessary for using flakes on this system.
  nix.settings = {
    trusted-users = [ "root" "drodriguez" ];
    experimental-features = "nix-command flakes";
  };

  # Fix for nixbld group GID mismatch
  ids.gids.nixbld = 30000;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    enableBashCompletion = true;
    variables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

  # Set default shell
  environment.shells = with pkgs; [ zsh ];

  # Add shell path
  environment.systemPath = [ "/opt/homebrew/bin" ];
  environment.pathsToLink = [ "/Applications" "/Applications/Utilities" "/Developer" "/Library" "/System" "/Users" "/Volumes" "/bin" "/etc" "/home" "/opt" "/private" "/sbin" "/tmp" "/usr" "/var" ];

  # OS Configurations
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    KeyRepeat = 2;
  };

  # Dock Configurations
  system.defaults.dock = {
    autohide = true;
  };

  # Finder Configurations 
  system.defaults.finder = {
    FXPreferredViewStyle = "clmv";
    ShowStatusBar = true;
    ShowPathbar = true;
  };

  # Applications
  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;

  # This enables touch id authentication for sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts to be installed system-wide.
  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.monaspace
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
  ];

  # Homebrew Casks
  homebrew = {
    enable = true;
    brews = [
      "terraform"
      "libpq"
      "snappy"
      # "mas" is removed since it's automatically installed by masApps
    ];
    casks = [
      "1password-cli"
      "1password"
      "arc"
      "aws-vault"
      "contour"
      "devtoys"
      "discord"
      "docker"
      "dropbox"
      "element"
      "figma"
      "firefox"
      "font-agave-nerd-font"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-meslo-lg-nerd-font"
      "google-chrome"
      "hammerspoon"
      "iina"
      "insomnia"
      "iterm2"
      "legcord"
      "ngrok"
      "notion"
      "obsidian"
      "openlens"
      "session-manager-plugin"
      "slack"
      "spotify"
      "todoist"
      "thunderbird"
      "vagrant"
      "visual-studio-code"
      "vlc"
      "wezterm"
      "zen-browser"
    ];
    masApps = {
      "The Unarchiver" = 425424353;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Create my user account.
  users.users.drodriguez = {
    name = "drodriguez";
    home = "/Users/drodriguez";
    shell = pkgs.zsh;
  };
}
