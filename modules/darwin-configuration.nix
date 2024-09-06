{ self, pkgs, ... }: 

{
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
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
      
      # Create my user account.
      users.users.drodriguez = {
          name = "drodriguez";
          home = "/Users/drodriguez";
      };
}