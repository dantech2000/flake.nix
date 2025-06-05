{ config, pkgs, lib, ... }:

{
  # Environment configuration
  environment.shells = with pkgs; [ zsh ];
  environment.systemPath = [ "/opt/homebrew/bin" ];
  environment.pathsToLink = [ 
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

  # macOS System Defaults
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    KeyRepeat = 2;
  };

  # Dock Configuration
  system.defaults.dock = {
    autohide = true;
  };

  # Finder Configuration 
  system.defaults.finder = {
    FXPreferredViewStyle = "clmv";
    ShowStatusBar = true;
    ShowPathbar = true;
  };


} 