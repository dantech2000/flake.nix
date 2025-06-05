{ lib, pkgs, ... }:

{
  imports = [
    ./programs
  ];

  # Home Manager version
  home.stateVersion = "25.05";

  # Core session variables that don't belong to specific programs
  home.sessionVariables = {
    GPG_TTY = "$(tty)";
    XDG_CONFIG_HOME = "$HOME/.config";
    LC_ALL = "en_US.UTF-8";
    LESS = "-R";
    SSH_CONFIG_DIR = "$HOME/.config/ssh";
  };

  # Home Manager self-management
  programs.home-manager.enable = true;

  # macOS-specific settings
  targets.darwin.defaults = lib.mkIf pkgs.stdenv.isDarwin {
    "com.apple.desktopservices".DSDontWriteNetworkStores = true;
  };
} 