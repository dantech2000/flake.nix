# Nix Darwin Configuration

This repository contains my personal Nix configuration for macOS, using nix-darwin and Home Manager. It provides a declarative way to manage both system-level and user-level configurations.

## Features

- **System Configuration**
  - Dark mode enabled by default
  - Touch ID authentication for sudo
  - Optimized keyboard repeat settings
  - Custom dock and finder preferences
  - System-wide Nerd Fonts installation

- **Development Environment**
  - Neovim configuration with extensive plugin support
  - Development tools for multiple languages (Go, Python, Terraform, etc.)
  - Git and GitHub CLI integration
  - Docker and Kubernetes tools (k9s, kubectl, helm)
  - AWS tools (aws-cli, session-manager-plugin)

- **Shell Environment**
  - Zsh as default shell with various enhancements:
    - **Starship Prompt**: A minimal, blazing-fast, and infinitely customizable prompt
    - **Oh My Zsh Integration**:
      - Theme: awesomepanda
      - Plugins: git, kubectl, brew, macos, colored-man-pages, virtualenv, terraform, tmux, docker, ssh-agent
    - **Shell Features**:
      - Vi mode with custom key bindings
      - History settings with incremental search
      - Advanced completion system with Carapace integration
      - Syntax highlighting and autosuggestions
      - Custom aliases for common commands

- **Environment Variables**
  - **XDG Base Directories**:
    - `XDG_CONFIG_HOME`: Set to `~/.config`
    - `ZDOTDIR`: Set to `~/.config/zsh`
    - `ZSH_COMPDUMP`: Set to `~/.cache/zsh/.zcompdump`

  - **Development Tools**:
    - `EDITOR`: Set to neovim
    - `GOPATH`: Set to `~/go`
    - `PYTHONDONTWRITEBYTECODE`: Prevents Python from creating .pyc files

  - **System Preferences**:
    - `LC_ALL`: Set to "en_US.UTF-8"
    - `LESS`: Set to "-R" for proper color support
    - `SSH_CONFIG_DIR`: Set to `~/.config/ssh`
    - `GPG_TTY`: Set dynamically for GPG signing
    - `umask`: Set to 022 for secure file permissions

  - **Search and Completion**:
    - `FZF_DEFAULT_COMMAND`: Uses ripgrep for better file searching
    - `FZF_DEFAULT_OPTS`: Customized for better display
    - `CARAPACE_BRIDGES`: Configured for cross-shell completion

- **Path Configuration**
  The configuration manages PATH additions for various tools:
  ```bash
  /usr/local/bin
  /usr/local/sbin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  /usr/local/opt/llvm/bin/clangd
  /Library/Frameworks/Python.framework/Versions/3.7/bin
  $GOROOT/bin
  $GOPATH/bin
  ```

- **Terminal Environment**
  - Modern CLI tools (bat, eza, ripgrep, fzf)

- **Applications**
  - Managed via Homebrew Casks:
    - Browsers: Arc, Firefox, Chrome
    - Development: VSCode, Zed, iTerm2, Wezterm, Docker
    - Productivity: 1Password, Notion, Obsidian
    - Communication: Slack, Discord, Zoom
    - Media: Spotify, VLC, IINA

## Prerequisites

- macOS
- Command Line Tools for Xcode: `xcode-select --install`

## Installation on macOS Sequoia

### 1. Install Nix (Recommended: Determinate Systems Installer)

On macOS Sequoia, use the Determinate Systems installer for best compatibility:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
```
- This installer sets up the multi-user daemon, enables flakes, and works seamlessly with macOS Sequoia.
- After installation, restart your terminal.

### 2. Install nix-darwin

```bash
nix run github:LnL7/nix-darwin --extra-experimental-features 'nix-command flakes'
```
- Follow the prompts to complete installation.
- You may need to add `/nix/var/nix/profiles/default/bin` to your `PATH` temporarily.

### 3. Clone This Configuration

```bash
git clone https://github.com/dantech2000/flake.nix.git ~/.config/nix-darwin
cd ~/.config/nix-darwin
```

### 4. Configure for Your Mac (New Host)

If you are setting up a new Mac:
1. Copy the host configuration file:
   ```bash
   cp modules/darwin/drodriguezs-MacBook-Pro.nix modules/darwin/<your-new-hostname>.nix
   ```
2. Edit the new file and set `networking.hostName = "<your-new-hostname>";` to match your Mac's hostname.
3. Edit `flake.nix` and add a new entry under `darwinConfigurations`:
   ```nix
   darwinConfigurations = {
     "drodriguezs-MacBook-Pro" = mkDarwinConfig { ... };
     "<your-new-hostname>" = mkDarwinConfig {
       system = "arm64-darwin"; # or "x86_64-darwin" for Intel
       hostname = "<your-new-hostname>";
       user = "<your-username>";
     };
   };
   ```

### 5. Build and Activate the Configuration

```bash
nix build .#darwinConfigurations.<your-new-hostname>.system
./result/sw/bin/darwin-rebuild switch --flake .#<your-new-hostname>
```
For subsequent updates:
```bash
darwin-rebuild switch --flake .#<your-new-hostname>
```

**Note:**
- Make sure your hostname matches the one in your configuration. You can check it with `scutil --get HostName` or change it via `sudo scutil --set HostName <your-new-hostname>`.
- The Determinate Systems installer enables flakes by default; no extra flake setup is needed.
- For Apple Silicon (M1/M2/M3), use `system = "arm64-darwin"` in your flake.

## Directory Structure

```
.
├── flake.nix              # Main configuration entry point
├── flake.lock            # Lock file for dependencies
├── modules/
│   ├── darwin/           # macOS-specific configurations
│   ├── home/            # User-specific configurations
│   ├── neovim/         # Neovim configuration
│   └── nixos/          # NixOS configurations
```

## Customization

### System Configuration
Edit `modules/darwin/<hostname>.nix` to modify:
- System packages
- macOS settings
- Homebrew packages and casks
- System-wide configurations

Note: Replace `<hostname>` with your machine's hostname (e.g., `drodriguezs-MacBook-Pro.nix`)

### Development Environment
The configuration includes a development shell that provides:
- `nixpkgs-fmt` for Nix code formatting
- `nil` for Nix language server support
- Git for version control
- Zsh as the default shell

To enter the development environment:
```bash
nix develop
```

### User Configuration
Edit `modules/home/home.nix` to modify:
- User packages
- Shell configurations
- Development tools
- Personal preferences

### Neovim Configuration
Edit files in `modules/neovim/` to modify:
- Plugin list
- Editor settings
- Language server configurations
- Key mappings

## Common Tasks

This project includes a Taskfile for common operations. To use it, make sure you have [Task](https://taskfile.dev) installed.

To see all available tasks:
```bash
task
```

Common tasks include:

- `task switch` - Rebuild and switch to the new configuration
- `task update` - Update flake inputs
- `task check` - Check the configuration for errors
- `task rollback` - Rollback to the previous generation
- `task clean` - Clean up old profiles and garbage collect
- `task edit` - Open the configuration in your editor

For system maintenance:
- `task gc` - Garbage collect old generations
- `task list-generations` - List all system generations
- `task history` - Show the history of configurations
- `task show-config` - Show the current system configuration

## VMware Fusion Setup Guide

### Prerequisites
- VMware Fusion Pro (recommended) or VMware Fusion Player
- At least 100GB of free disk space
- NixOS ISO image (preferably the latest stable release)

### VM Configuration Best Practices

#### Hardware Settings
1. **Processors & Memory**:
   - CPUs: At least 2 cores (4 recommended)
   - Memory: Minimum 4GB (8GB recommended)
   - Enable "Hypervisor" options for better performance
   ```
   Settings > System Settings > Processors & Memory:
   - [x] Enable hypervisor applications
   - [x] Enable code profiling applications
   ```

2. **Display**:
   ```
   Settings > Display:
   - [x] Accelerate 3D Graphics
   - [x] Use full resolution for Retina display
   - Graphics Memory: 2GB
   ```

3. **Hard Disk**:
   - Size: 60GB minimum (100GB recommended)
   - Bus type: NVMe (for better performance)
   - Split into multiple files: Yes
   ```
   Settings > Hard Disk:
   - [x] Pre-allocate disk space
   - [x] Enable defragmentation
   ```

4. **Network Adapter**:
   ```
   Settings > Network Adapter:
   - Connect at power on: Yes
   - Network Type: NAT
   - [x] Enable IPv4
   - [x] Enable IPv6
   ```

5. **USB & Bluetooth**:
   ```
   Settings > USB & Bluetooth:
   - USB Compatibility: USB 3.1
   - [x] Share Bluetooth devices with Linux
   ```

6. **Sharing**:
   ```
   Settings > Sharing:
   - [x] Enable Shared Folders
   - [x] Enable Drag and Drop
   - [x] Enable Copy and Paste
   ```

### Performance Optimization

1. **VMware Tools Settings**:
   ```nix
   # Already included in vm.nix
   virtualisation.vmware.guest.enable = true;
   services.vmware.guest = {
     enable = true;
     headless = false;
   };
   ```

2. **Disk Performance**:
   ```
   Settings > Advanced:
   - [x] Enable disk performance optimization
   - Hard disk buffering: Enabled
   ```

3. **Memory Management**:
   ```
   Settings > Advanced:
   - [x] Enable page sharing
   - [x] Enable memory trimming
   ```

### Recommended VM Creation Steps

1. Create New Virtual Machine:
   ```
   File > New > Create a custom virtual machine
   ```

2. Choose Operating System:
   ```
   Linux > Other Linux 5.x kernel 64-bit
   ```

3. Configure VM:
   ```
   - Name: NixOS-Development
   - Save As: ~/Virtual Machines/
   - Firmware Type: UEFI
   ```

4. Customize Settings:
   ```
   Settings > General:
   - [x] Pass Power Status to VM
   - [x] Support for Mac OS Keyboard
   ```

5. Additional Software:
   ```
   # Already included in vm.nix
   environment.systemPackages = with pkgs; [
     open-vm-tools
     xorg.xrandr
     spice-vdagent
     # Development tools
     git
     vim
     curl
     wget
   ];
   ```

### Troubleshooting Tips

1. **Display Issues**:
   - If resolution is wrong: `sudo vmware-resolutionSet 1920 1080`
   - If screen is laggy: Enable 3D acceleration and increase graphics memory

2. **Network Issues**:
   - If NAT doesn't work: Try bridged networking
   - If DNS is slow: Add `networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];`

3. **Performance Issues**:
   - If VM is slow: Increase CPU/RAM allocation
   - If disk I/O is slow: Enable NVMe and pre-allocate disk space

4. **Shared Folders**:
   - Mount point: `/mnt/hgfs/`
   - Auto-mount: Add to `/etc/fstab`
   - Permissions: Use `vmhgfs-fuse`

### Post-Installation Optimization

1. **Check VMware Tools**:
   ```bash
   systemctl status vmware-tools
   ```

2. **Verify 3D Acceleration**:
   ```bash
   glxinfo | grep "direct rendering"
   ```

3. **Test Shared Folders**:
   ```bash
   # Mount shared folders
   sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other
   ```

4. **Monitor Performance**:
   ```bash
   # Install monitoring tools
   nix-env -iA nixos.htop nixos.iotop
   ```

## Testing in VMware Fusion

To test this configuration in VMware Fusion:

1. Download the latest NixOS ISO from https://nixos.org/download.html

2. Create a new VM in VMware Fusion:
   - Click "New" or File > New
   - Choose "Install from disc or image"
   - Select the downloaded NixOS ISO
   - Choose "Linux" > "Other Linux 5.x kernel 64-bit"
   - Configure VM settings:
     - At least 4GB RAM
     - At least 2 CPU cores
     - 60GB disk space
     - Enable 3D acceleration
     - Network adapter: NAT

3. Install NixOS:
   ```bash
   # Format the disk (assuming /dev/sda)
   sudo parted /dev/sda -- mklabel gpt
   sudo parted /dev/sda -- mkpart primary 512MB -8GB
   sudo parted /dev/sda -- mkpart primary linux-swap -8GB 100%
   sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
   sudo parted /dev/sda -- set 3 esp on

   # Format partitions
   sudo mkfs.ext4 -L nixos /dev/sda1
   sudo mkswap -L swap /dev/sda2
   sudo mkfs.fat -F 32 -n boot /dev/sda3

   # Mount partitions
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/boot /mnt/boot
   sudo swapon /dev/sda2
   ```

4. Clone and activate the configuration:
   ```bash
   # Install git
   nix-env -iA nixos.git

   # Clone your configuration
   git clone https://github.com/yourusername/nix-config.git /mnt/etc/nixos
   
   # Generate hardware configuration
   sudo nixos-generate-config --root /mnt

   # Copy the generated hardware-configuration.nix
   cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/modules/nixos/

   # Install NixOS with your configuration
   sudo nixos-install --flake .#nixos-vm
   ```

5. After installation:
   - Remove the ISO from the VM
   - Reboot
   - Log in with username: `drodriguez` and password: `changeme`
   - Change your password immediately using `passwd`

Note: The configuration includes VMware-specific settings:
- VMware guest tools
- Proper display drivers
- Network interface configuration
- Shared folder support
- Hardware acceleration support

## Maintenance

### Updating the System
```bash
# Pull latest changes
git pull origin main

# Update and switch to new configuration
darwin-rebuild switch --flake .#<your-new-hostname>
```

### Cleaning Up
```bash
# Remove old generations
sudo nix-collect-garbage -d

# Remove specific generation
nix-env --delete-generations [generation-number]
```

## Troubleshooting

### Common Issues

1. **Dirty Git Tree Warning**
   ```bash
   # Check status
   git status
   
   # Commit or stash changes
   git add .
   git commit -m "Update configuration"
   ```

2. **Homebrew Issues**
   ```bash
   # Repair Homebrew
   brew doctor
   
   # Update Homebrew
   brew update
   ```

3. **Configuration Not Taking Effect**
   - Ensure you're using the correct hostname in the flake configuration
   - Try rebuilding with `--show-trace` for more detailed error messages
   ```bash
   darwin-rebuild switch --flake .#drodriguezs-MacBook-Pro --show-trace
   ```

4. **Nix Store Issues**
   ```bash
   # Clear derivation links
   sudo rm /nix/var/nix/gcroots/auto/*
   
   # Optimize nix store
   nix store optimise
   ```

5. **Flake Lock Issues**
   ```bash
   # Update flake inputs
   nix flake update
   
   # Update specific input
   nix flake lock --update-input nixpkgs
   ```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
