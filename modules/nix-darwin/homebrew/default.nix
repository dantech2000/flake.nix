_:

{
  # Homebrew Configuration
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

    # Homebrew Taps
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
      {
        name = "sst/tap";
        clone_target = "https://github.com/sst/homebrew-tap";
        force_auto_update = true;
      }
    ];

    # Homebrew Formulae
    brews = [
      "docker"
      "golangci-lint"
      "libffi"
      "libpq"
      "libyaml"
      "opencode"
      "readline"
      "refresh"
      "shopify/shopify/shopify-cli"
      "snappy"
      "tfenv"
    ];

    # Homebrew Casks
    casks = [
      "1password-cli"
      "1password"
      "arc"
      "aws-vault-binary"
      "contour"
      "cursor"
      "brave-browser"
      "devtoys"
      "displaylink"
      "discord"
      "docker-desktop"
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
      "notion"
      "obsidian"
      "rectangle"
      "raycast"
      "session-manager-plugin"
      "slack"
      "telegram"
      "todoist-app"
      "vagrant"
      "visual-studio-code"
      "vlc"
      "zed"
      "zen"
    ];
  };
}
