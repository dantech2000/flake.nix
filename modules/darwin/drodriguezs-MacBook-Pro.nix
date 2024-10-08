{ self, pkgs, config, ... }: 

{
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.mkalias
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.zsh.enableFzfCompletion  = true;
      programs.zsh.enableFzfHistory = true;
      programs.zsh.enableSyntaxHighlighting = true;

      # OS Configurations
      system.defaults.NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      system.defaults.dock = {
        autohide = true;
      };

      system.defaults.finder = {
        ShowStatusBar = true;
        ShowPathbar = true;
      };

      system.activationScripts.applications.text = let
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
        while read src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';
  

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
      nixpkgs.config.allowUnfree = true;

      # This enables touch id authentication for sudo.
      security.pam.enableSudoTouchIdAuth = true;

      # Fonts to be installed system-wide.
      fonts.packages = with pkgs; [
        nerdfonts
      ];

      # Homebrew Casks
      homebrew = {
        enable = true;
        casks = [
          "1password"
          "1password-cli"
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
          "google-cloud-sdk"
          "insomnia"
          "iterm2"
          "ngrok"
          "notion"
          "openlens"
          "session-manager-plugin"
          "slack"
          "spotify"
          "vagrant"
          "visual-studio-code"
          "vlc"
          "wezterm"
          "zed"
          "arc"
          "zoom"
        ];
      };
      
      # Create my user account.
      users.users.drodriguez = {
          name = "drodriguez";
          home = "/Users/drodriguez";
      };
}