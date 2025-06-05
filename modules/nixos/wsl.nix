# WSL-specific configuration
{ pkgs, ... }:

{
  wsl = {
    enable = true;
    defaultUser = "drodriguez";
    # Enable native systemd support
    nativeSystemd = true;
    
    # WSL configuration
    wslConf = {
      # Enable integration with Windows paths
      automount = {
        root = "/mnt";
        options = "metadata";
      };
      # Enable integration with Windows system
      interop = {
        enabled = true;
        appendWindowsPath = true;
      };
    };
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
