# VMware-specific NixOS configuration
{ config, pkgs, ... }:

{
  # Basic system configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VMware-specific settings
  virtualisation.vmware.guest.enable = true;

  # Network configuration
  networking = {
    useDHCP = true;
    # Enable VMware's network interfaces
    interfaces = {
      ens33.useDHCP = true; # Common VMware interface name
      ens34.useDHCP = true; # Secondary interface if needed
    };
  };

  # Services configuration
  services = {
    # Enable OpenSSH daemon
    openssh.enable = true;

    # VMware guest services
    vmware.guest = {
      enable = true;
      headless = false;
    };

    # Enable X11 and basic desktop environment
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # VMware display settings
      videoDrivers = [ "vmware" ];

      # Better resolution handling
      resolutions = [
        { x = 1920; y = 1080; }
        { x = 1600; y = 900; }
        { x = 1366; y = 768; }
      ];
    };
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    open-vm-tools # VMware tools
    xorg.xrandr # For display management
  ];

  # Set your time zone
  time.timeZone = "America/Los_Angeles";

  # Enable automatic system upgrades
  system.autoUpgrade.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # System-wide environment variables
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Create the user with sudo access
  users.users.drodriguez = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "changeme"; # Remember to change this on first login
  };

  # Enable sudo without password for wheel group
  security.sudo.wheelNeedsPassword = false;
}
