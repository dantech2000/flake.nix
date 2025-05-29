{ self, pkgs, config, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.aws-sam-cli
      pkgs.vim
      pkgs.starship
      pkgs.mkalias
      pkgs.nixpkgs-fmt
      pkgs.nodejs
      pkgs.gitAndTools.gitFull
    ];

  # Auto upgrade nix package and the daemon service.
  nix.enable = false;

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
  nixpkgs.hostPlatform = "aarch64-darwin";
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
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    global = {
      brewfile = true;
      lockfiles = true;
    };
    taps = [
      {
        name = "shopify/shopify";
        clone_target = "https://github.com/Shopify/homebrew-shopify";
        force_auto_update = false;
      }
      {
        name = "hashicorp/tap";
        clone_target = "https://github.com/hashicorp/homebrew-tap";
      }
      {
        name = "dantech2000/tap";
        clone_target = "https://github.com/dantech2000/homebrew-tap";
        force_auto_update = true;
      }
    ];
    brews = [
      "libpq"
      "snappy"
      "shopify/shopify/shopify-cli"
      "tfenv"
      "refresh"
    ];
    casks = [
      "1password-cli"
      "1password"
      "arc"
      "aws-vault"
      "contour"
      "cursor"
      "brave-browser"
      "devtoys"
      "displaylink"
      "docker"
      "dropbox"
      "element"
      "firefox"
      "font-agave-nerd-font"
      "font-fira-code"
      "font-hack-nerd-font"
      "font-meslo-lg-nerd-font"
      "google-chrome"
      "hammerspoon"
      "iina"
      "insomnia"
      "legcord"
      "notion"
      "ngrok"
      "obsidian"
      "rectangle"
      "raycast"
      "session-manager-plugin"
      "slack"
      "spotify"
      "telegram"
      "todoist"
      "vagrant"
      "visual-studio-code"
      "vlc"
      "zen"
    ];
  };

  # Create my user account.
  users.users.drodriguez = {
    name = "drodriguez";
    home = "/Users/drodriguez";
    shell = pkgs.zsh;
  };
}
