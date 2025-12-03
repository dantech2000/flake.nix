_: {
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
        name = "codecademy-engineering/engineering";
        clone_target = "https://github.com/codecademy-engineering/homebrew-bootstrap";
      }
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
        name = "sst/tap";
        clone_target = "https://github.com/sst/homebrew-tap";
        force_auto_update = true;
      }
      {
        name = "kreuzwerker/taps";
        clone_target = "https://github.com/kreuzwerker/homebrew-taps";
        force_auto_update = true;
      }
      {
        name = "dantech2000/homebrew-tap";
        clone_target = "https://github.com/dantech2000/homebrew-tap";
        force_auto_update = true;
      }
    ];

    # Homebrew Formulae
    brews = [
      "docker"
      "golangci-lint"
      "helm@3.14.4"
      "helmfile@0.144.0"
      "libffi"
      "libpq"
      "libyaml"
      "opencode"
      "readline"
      "shopify/shopify/shopify-cli"
      "snappy"
      "tfenv"
      "kreuzwerker/taps/m1-terraform-provider-helper"
      "codex"
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
      "ghostty"
      "hammerspoon"
      "iina"
      "insomnia"
      "mongodb-compass"
      "notion"
      "obsidian"
      "rectangle"
      "raycast"
      "dantech2000/homebrew-tap/refresh"
      "session-manager-plugin"
      "slack"
      # "tailscale-app"
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
