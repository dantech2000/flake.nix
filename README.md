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

- **Terminal Environment**
  - Zsh as default shell with various enhancements:
    - FZF integration for completion and history
    - Syntax highlighting
    - Starship prompt
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

## Installation

1. **Install Nix**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
   ```
   This installer provides several advantages:
   - Automatic system configuration
   - Automatic daemon installation and startup
   - Built-in support for Flakes
   - Easy uninstallation if needed

2. **Clone this repository**
   ```bash
   git clone https://github.com/dantech2000/flake.nix.git ~/.config/nix-darwin
   cd ~/.config/nix-darwin
   ```

3. **Build and activate the configuration**
   ```bash
   # First time setup
   nix build .#darwinConfigurations.drodriguezs-MacBook-Pro.system
   ./result/sw/bin/darwin-rebuild switch --flake .#drodriguezs-MacBook-Pro

   # Subsequent updates
   darwin-rebuild switch --flake .#drodriguezs-MacBook-Pro
   ```

   Note: The Determinate Systems installer enables flakes by default, so no additional configuration is needed.

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

## Maintenance

### Updating the System
```bash
# Pull latest changes
git pull origin main

# Update and switch to new configuration
darwin-rebuild switch --flake .#drodriguezs-MacBook-Pro
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
