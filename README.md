# Nix Darwin Configuration

This repository contains my personal Nix configuration for macOS, using nix-darwin and Home Manager. It provides a declarative way to manage both system-level and user-level configurations with a **modular, maintainable structure**.

## Architecture

This configuration is built with a **modular design** that separates concerns and makes maintenance easy:

### Home Manager Modules (User Environment)
- **`neovim.nix`** - Complete Neovim configuration with plugins and LSP
- **`zsh.nix`** - Shell configuration with oh-my-zsh, powerlevel10k, and plugins  
- **`development.nix`** - Development tools, languages, git, and DevOps tools
- **`cli-tools.nix`** - Command-line utilities and system tools

### Nix-Darwin Modules (System Configuration)
- **`fonts.nix`** - System-wide Nerd Fonts installation
- **`security.nix`** - TouchID authentication and security settings
- **`users.nix`** - User account management
- **`system.nix`** - macOS system defaults (dock, finder, global settings)
- **`programs.nix`** - System packages, ZSH, and application setup
- **`homebrew.nix`** - Comprehensive package management via Homebrew
- **`spicetify.nix`** - Spotify customization with themes and extensions

## Features

### System Configuration (Nix-Darwin)
- **macOS Defaults**: Dark mode, optimized keyboard repeat, custom dock/finder preferences
- **Security**: TouchID authentication for sudo
- **Fonts**: System-wide Nerd Fonts (JetBrains Mono, Fira Code, Monaspace, etc.)
- **Package Management**: 44+ applications via Homebrew (Arc, VSCode, Docker, etc.)
- **Core Tools**: System packages for development and productivity
- **Music**: Spotify customization via Spicetify with TokyoNight theme and 17+ extensions

### Development Environment (Home Manager)
- **Editor**: Neovim with extensive plugin support and LSP configuration
- **Languages**: Go, Python, Rust, Node.js, with proper toolchains
- **DevOps**: Docker, Kubernetes (k9s, kubectl, helm), Terraform, Ansible
- **Cloud**: AWS CLI, session-manager-plugin, aws-vault
- **Version Control**: Git with comprehensive configuration and GitHub CLI

### Shell Environment (ZSH)
- **Prompt**: Starship prompt with custom configuration
- **Framework**: Oh My Zsh with curated plugins
- **Features**: 
  - Syntax highlighting and autosuggestions
  - FZF integration for fuzzy finding
  - Carapace for advanced completions
  - Custom aliases and functions
  - Powerlevel10k theme support

### CLI Tools
- **Modern Replacements**: bat (cat), eza (ls), ripgrep (grep), zoxide (cd)
- **Productivity**: htop, neofetch, tldr, tmux
- **File Processing**: jq, yq, ffmpeg, imagemagick
- **Network**: curl, wget, dnsmasq

## Directory Structure

```
├── flake.nix                          # Main configuration entry point
├── flake.lock                         # Lock file for dependencies  
├── modules/
│   ├── darwin/                        # Machine-specific core settings
│   │   └── MAC-RNJMGYX0J5.nix        # Core nix-darwin configuration
│   ├── home-manager/                  # User Environment (Modular)
│   │   ├── default.nix               # Home Manager entry point
│   │   ├── config/                   # Configuration files
│   │   │   ├── p10k/                 # Powerlevel10k theme
│   │   │   └── starship/             # Starship prompt config
│   │   └── programs/                 # User program modules
│   │       ├── neovim.nix           # Editor configuration
│   │       ├── zsh.nix              # Shell configuration  
│   │       ├── development.nix      # Dev tools & languages
│   │       └── cli-tools.nix        # CLI utilities
│   ├── nix-darwin/                   # System Configuration (Modular)
│   │   ├── default.nix              # Nix-Darwin entry point
│   │   ├── fonts/                   # Font management
│   │   ├── security/                # Security settings
│   │   ├── users/                   # User accounts
│   │   ├── system/                  # macOS defaults
│   │   ├── programs/                # System packages
│   │   ├── homebrew/                # Package management
│   │   └── spicetify/               # Spotify customization
│   ├── nixos/                       # Linux configurations
│   └── shared/                      # Shared components
├── README.md                        # This file
└── Taskfile.yml                     # Common tasks automation
```

## Quick Start

### Prerequisites
- macOS (tested on Sequoia)
- Command Line Tools: `xcode-select --install`

### 1. Install Nix (Determinate Systems)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
```

### 2. Install nix-darwin
```bash
nix run github:LnL7/nix-darwin --extra-experimental-features 'nix-command flakes'
```

### 3. Clone & Apply Configuration
```bash
git clone https://github.com/dantech2000/flake.nix.git ~/.config/nix-darwin
cd ~/.config/nix-darwin

# For existing machines (MAC-RNJMGYX0J5)
darwin-rebuild switch --flake .#MAC-RNJMGYX0J5

# For new machines - see "New Machine Setup" below
```

## New Machine Setup

### 1. Create Machine Configuration
```bash
# Copy the core settings template  
cp modules/darwin/MAC-RNJMGYX0J5.nix modules/darwin/<your-hostname>.nix

# Edit the file for your machine
vim modules/darwin/<your-hostname>.nix
```

### 2. Update Flake Configuration
Edit `flake.nix` and add your machine:
```nix
darwinConfigurations = {
  "MAC-RNJMGYX0J5" = mkDarwinConfig { ... };
  "<your-hostname>" = mkDarwinConfig {
    system = "aarch64-darwin";  # or "x86_64-darwin" for Intel
    hostname = "<your-hostname>";
    user = "<your-username>";
  };
};
```

### 3. Apply Configuration
```bash
darwin-rebuild switch --flake .#<your-hostname>
```

## Customization

### System Configuration (Nix-Darwin)
- **Fonts**: Edit `modules/nix-darwin/fonts/default.nix`
- **macOS Settings**: Edit `modules/nix-darwin/system/default.nix`
- **Homebrew Packages**: Edit `modules/nix-darwin/homebrew/default.nix`
- **System Packages**: Edit `modules/nix-darwin/programs/default.nix`
- **Spotify Customization**: Edit `modules/nix-darwin/spicetify/default.nix`

### User Configuration (Home Manager)  
- **Shell**: Edit `modules/home-manager/programs/zsh.nix`
- **Editor**: Edit `modules/home-manager/programs/neovim.nix`
- **Dev Tools**: Edit `modules/home-manager/programs/development.nix`
- **CLI Tools**: Edit `modules/home-manager/programs/cli-tools.nix`

### Adding New Modules
The modular structure makes it easy to add new functionality:

1. **System Module**: Create `modules/nix-darwin/<name>/default.nix`
2. **User Module**: Create `modules/home-manager/programs/<name>.nix`
3. **Import**: Add to respective `imports` list in `default.nix`

## Common Tasks

This project includes a Taskfile for common operations:

```bash
task                    # List all available tasks
task switch            # Rebuild and switch configuration
task update            # Update flake inputs
task check             # Check configuration for errors
task rollback          # Rollback to previous generation
task clean             # Clean up old profiles
task gc                # Garbage collect old generations
```

## Environment Details

### Environment Variables
- **XDG Directories**: `XDG_CONFIG_HOME`, `ZDOTDIR`, `ZSH_COMPDUMP`
- **Development**: `EDITOR=nvim`, `GOPATH`, `PYTHONDONTWRITEBYTECODE`
- **System**: `LC_ALL`, `LESS`, `SSH_CONFIG_DIR`, `GPG_TTY`
- **Search**: `FZF_*` variables, `CARAPACE_BRIDGES`

### Path Configuration
```bash
/usr/local/bin:/usr/local/sbin
/opt/homebrew/bin:/opt/homebrew/sbin
$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin
/usr/local/opt/llvm/bin
$GOROOT/bin:$GOPATH/bin
```

### Shell Features
- **Theme**: Oh My Zsh with awesomepanda theme or Powerlevel10k
- **Plugins**: git, kubectl, brew, macos, colored-man-pages, terraform, docker
- **Enhancements**: vi mode, history search, syntax highlighting, autosuggestions

## Maintenance

### Updating
```bash
git pull origin main                    # Pull latest changes
task update                            # Update flake inputs  
task switch                            # Apply changes
```

### Cleaning Up
```bash
task clean                             # Clean old profiles
task gc                               # Garbage collect
sudo nix-collect-garbage -d           # System-wide cleanup
```

## Troubleshooting

### Common Issues

1. **Dirty Git Tree Warning**
   ```bash
   git add . && git commit -m "Local changes"
   ```

2. **Configuration Conflicts**
   ```bash
   darwin-rebuild switch --flake .#<hostname> --show-trace
   ```

3. **Homebrew Issues**
   ```bash
   brew doctor && brew update
   ```

4. **Module Not Found**
   - Check imports in `default.nix` files
   - Verify module file paths and names
   - Ensure new files are added to git

## Benefits of Modular Structure

- **Easy Maintenance**: Each component in its own file
- **Clear Organization**: Logical separation by functionality  
- **Faster Development**: Modify only what you need
- **Better Documentation**: Self-documenting structure
- **Reusability**: Modules can be easily shared or adapted
- **Testing**: Test individual components independently

## Development Environment

To work on this configuration:
```bash
nix develop                           # Enter development shell
task check                           # Validate configuration
task switch                          # Test changes
```

The development shell provides:
- `nixpkgs-fmt` for code formatting
- `nil` language server for Nix
- `statix` for linting
- All development tools

## System Overview

- **Total Packages**: 100+ via Nix + 44+ via Homebrew
- **Modular Components**: 11 specialized modules  
- **Configuration Files**: Organized and templated
- **Maintenance Burden**: Minimal thanks to modular design
- **Platform Support**: macOS (primary), NixOS (vm/testing)
- **Music Enhancement**: Spotify with 17+ extensions and custom theming

## VMware Fusion Testing

### Prerequisites
- VMware Fusion Pro (recommended) or VMware Fusion Player
- At least 100GB of free disk space
- NixOS ISO image (preferably the latest stable release)

### Quick VM Setup
1. **Download NixOS ISO**: Get from https://nixos.org/download.html
2. **Create VM**: Use "Linux" > "Other Linux 5.x kernel 64-bit"
3. **Configure**: 4GB RAM, 2+ CPU cores, 60GB disk, 3D acceleration enabled
4. **Install**: Standard NixOS installation process
5. **Apply Config**: Clone this repo and use the `nixos-vm` configuration

### Optimized VM Settings
```
Hardware:
- Memory: 4GB+ (8GB recommended)  
- CPUs: 2+ cores (4 recommended)
- Graphics: 2GB, 3D acceleration enabled
- Network: NAT with IPv4/IPv6 enabled
- USB: 3.1 compatibility
- Shared folders enabled for development
```

The configuration includes VMware-specific optimizations:
- VMware guest tools integration
- Proper display drivers and resolution detection
- Network interface configuration  
- Shared folder support
- Hardware acceleration support

This allows testing the NixOS modules in a virtualized environment while developing the macOS configuration.

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

## Additional Resources

- **Nix Manual**: https://nixos.org/manual/nix/stable/
- **Nix-Darwin Documentation**: https://github.com/LnL7/nix-darwin
- **Home Manager Manual**: https://nix-community.github.io/home-manager/
- **NixOS Search**: https://search.nixos.org/packages
- **Community Wiki**: https://nixos.wiki/

## Contributing

Contributions are welcome! Please feel free to:
- Report bugs and issues
- Suggest new features or improvements  
- Submit pull requests for enhancements
- Share your own modular configurations

## License

This project is licensed under the MIT License - see the LICENSE file for details.
