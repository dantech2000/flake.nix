{pkgs, ...}: {
  # Environment configuration
  environment = {
    shells = with pkgs; [zsh];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = [
      "/Applications"
      "/Applications/Utilities"
      "/Developer"
      "/Library"
      "/System"
      "/Users"
      "/Volumes"
      "/bin"
      "/etc"
      "/home"
      "/opt"
      "/private"
      "/sbin"
      "/tmp"
      "/usr"
      "/var"
    ];
  };

  # macOS System Defaults
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      KeyRepeat = 2;
    };

    # Dock Configuration
    dock = {
      autohide = true;
    };

    # Finder Configuration
    finder = {
      FXPreferredViewStyle = "clmv";
      ShowStatusBar = true;
      ShowPathbar = true;
    };
  };
}
