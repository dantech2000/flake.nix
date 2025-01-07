# WSL-specific configuration
{ config, pkgs, lib, ... }:

{
  wsl = {
    enable = true;
    defaultUser = "drodriguez";
    # Enable integration with Windows paths
    wslConf.automount.root = "/mnt";
    wslConf.automount.options = "metadata";
    # Enable integration with Windows system
    wslConf.interop.enabled = true;
    wslConf.interop.appendWindowsPath = true;
    # Enable native systemd support
    nativeSystemd = true;
  };

  # WSL-specific system configuration
  system.stateVersion = "23.11";

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Basic system packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
  ];

  # Configure OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Configure user
  users.users.drodriguez = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable sudo
    shell = pkgs.zsh;
  };
}
