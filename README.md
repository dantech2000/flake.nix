# Nix Darwin Configuration

This repository contains my personal Nix configuration for macOS, using nix-darwin and Home Manager. It provides a declarative way to manage both system-level and user-level configurations with a **modular, maintainable structure**.

## Architecture

This configuration is built with a **modular design** that separates concerns and makes maintenance easy:

### Home Manager Modules (User Environment)
- **`nixvim.nix`** - Declarative Neovim configuration using nixvim (see modules/home-manager/programs/nixvim/README.md)
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
- **Editor**: Neovim configured with nixvim - declarative, modular, and reproducible
  - LSP support for 15+ languages (Go, TypeScript, Rust, Nix, etc.)
  - Treesitter for advanced syntax highlighting
  - Telescope for fuzzy finding
  - Harpoon for quick file navigation
  - GitHub Copilot integration
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
├── hosts/                             # Host-specific configurations
│   ├── MAC-RNJMGYX0J5/               # Apple Silicon Mac (work)
│   │   └── default.nix               # Host-specific settings
│   ├── nebula/                       # Intel Mac
│   │   └── default.nix               # Host-specific settings
│   └── serenity/                     # Linux workstation
│       └── default.nix               # Host-specific settings
├── modules/
│   ├── home-manager/                  # User Environment (Modular)
│   │   ├── default.nix               # Home Manager entry point
│   │   ├── config/                   # Configuration files
│   │   │   ├── p10k/                 # Powerlevel10k theme
│   │   │   └── starship/             # Starship prompt config
│   │   └── programs/                 # User program modules
│   │       ├── nixvim.nix           # Nixvim entry point
│   │       ├── nixvim/              # Modular Neovim config
│   │       │   ├── options.nix      # Vim options
│   │       │   ├── keymaps.nix      # Keybindings
│   │       │   ├── lsp.nix          # LSP servers
│   │       │   ├── completion.nix   # Completion & snippets
│   │       │   ├── autocommands.nix # Autocommands
│   │       │   ├── plugins/         # Plugin configurations
│   │       │   └── README.md        # Neovim documentation
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

# For Apple Silicon Mac (work)
darwin-rebuild switch --flake .#MAC-RNJMGYX0J5

# For Intel Mac
darwin-rebuild switch --flake .#nebula

# For Linux workstation (home-manager only)
home-manager switch --flake .#serenity

# For new machines - see "New Machine Setup" below
```

## New Machine Setup

### 1. Create Host Configuration
```bash
# Create a new host directory
mkdir -p hosts/<your-hostname>

# Copy an existing host configuration as a template
cp hosts/MAC-RNJMGYX0J5/default.nix hosts/<your-hostname>/default.nix

# Edit the file for your machine
vim hosts/<your-hostname>/default.nix
```

### 2. Update Flake Configuration
Edit `flake.nix` and add your machine to the appropriate section:

**For macOS (Darwin):**
```nix
darwinConfigurations = {
  "MAC-RNJMGYX0J5" = mkDarwinConfig { ... };
  "nebula" = mkDarwinConfig { ... };
  "<your-hostname>" = mkDarwinConfig {
    system = "aarch64-darwin";  # or "x86_64-darwin" for Intel
    hostname = "<your-hostname>";
    inherit user;  # or user = "<your-username>";
    extraModules = [ ./hosts/<your-hostname> ];
  };
};
```

**For Linux (Home Manager only):**
```nix
homeConfigurations = {
  "serenity" = mkHomeManagerConfig { ... };
  "<your-hostname>" = mkHomeManagerConfig {
    system = "x86_64-linux";  # or "aarch64-linux" for ARM
    hostname = "<your-hostname>";
    inherit user;  # or user = "<your-username>";
    extraModules = [ ./hosts/<your-hostname> ];
  };
};
```

### 3. Apply Configuration
```bash
# For macOS
darwin-rebuild switch --flake .#<your-hostname>

# For Linux (home-manager only)
home-manager switch --flake .#<your-hostname>
```

## Customization

### Host-Specific Configuration
Each host has its own configuration directory under `hosts/<hostname>/`:
- **Core Settings**: Edit `hosts/<hostname>/default.nix`
- **Platform Settings**: Adjust `nixpkgs.hostPlatform` for your architecture
- **Host-Specific Packages**: Add packages unique to that machine
- **Hardware Settings**: Configure hardware-specific options

### System Configuration (Nix-Darwin)
These modules are shared across all Darwin hosts:
- **Fonts**: Edit `modules/nix-darwin/fonts/default.nix`
- **macOS Settings**: Edit `modules/nix-darwin/system/default.nix`
- **Homebrew Packages**: Edit `modules/nix-darwin/homebrew/default.nix`
- **System Packages**: Edit `modules/nix-darwin/programs/default.nix`
- **Spotify Customization**: Edit `modules/nix-darwin/spicetify/default.nix`

### User Configuration (Home Manager)
These modules are shared across all hosts:
- **Shell**: Edit `modules/home-manager/programs/zsh.nix`
- **Editor**: Edit files in `modules/home-manager/programs/nixvim/` (see nixvim/README.md for details)
- **Dev Tools**: Edit `modules/home-manager/programs/development.nix`
- **CLI Tools**: Edit `modules/home-manager/programs/cli-tools.nix`

### Adding New Modules
The modular structure makes it easy to add new functionality:

1. **Host-Specific Module**: Create/edit `hosts/<hostname>/default.nix`
2. **System Module**: Create `modules/nix-darwin/<name>/default.nix`
3. **User Module**: Create `modules/home-manager/programs/<name>.nix`
4. **Import**: Add to respective `imports` list in `default.nix`

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
- **Host-Specific Configs**: Easy per-machine customization via `hosts/` directory
- **Shared Modules**: Common settings in `modules/` reused across all hosts
- **Faster Development**: Modify only what you need
- **Better Documentation**: Self-documenting structure
- **Reusability**: Modules can be easily shared or adapted
- **Multi-Platform**: Support for Darwin (macOS) and Linux hosts
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
- **Configured Hosts**: 3 (MAC-RNJMGYX0J5, nebula, serenity)
- **Configuration Files**: Organized and templated
- **Maintenance Burden**: Minimal thanks to modular design
- **Platform Support**: macOS (Darwin) - Apple Silicon & Intel, Linux (x86_64)
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

## Managing Secrets with SOPS

This configuration uses [SOPS](https://github.com/getsops/sops) with [age](https://github.com/FiloSottile/age) encryption for secure secrets management. Secrets are stored encrypted in `secrets/secrets.yaml` and decrypted at build time.

### Prerequisites

Ensure your age key is set up:
```bash
# Verify the age key file exists
cat ~/.config/sops/age/keys.txt

# If not, derive it from your SSH key
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

### Adding a New Secret

**Step 1: Edit the encrypted secrets file**
```bash
cd ~/.config/nix-darwin
sops secrets/secrets.yaml
```
This opens the file in your editor with values decrypted. Add your new secret using YAML syntax:
```yaml
ssh:
    id_ed25519: <existing-value>
my_new_secret: your-secret-value-here
```
Save and close. SOPS automatically re-encrypts the file.

**Step 2: Reference the secret in Nix configuration**

Edit `modules/home-manager/programs/sops.nix` and add the secret to the `sops.secrets` attribute:
```nix
sops.secrets = {
  "ssh/id_ed25519" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mode = "0600";
  };
  # Add your new secret
  "my_new_secret" = {
    path = "${config.home.homeDirectory}/.config/my-app/secret";
    mode = "0600";
  };
};
```

**Step 3: Rebuild the configuration**
```bash
task switch
# or
darwin-rebuild switch --flake .#<hostname>
```

### Useful SOPS Commands

```bash
# Edit secrets (decrypts, opens editor, re-encrypts on save)
sops secrets/secrets.yaml

# View decrypted secrets (read-only)
sops -d secrets/secrets.yaml

# Rotate keys (re-encrypt with new keys)
sops updatekeys secrets/secrets.yaml

# Encrypt a new file
sops -e newfile.yaml > secrets/newfile.yaml
```

### Nested Secrets

For nested YAML structures, use forward slashes in the secret name:
```yaml
# In secrets/secrets.yaml
database:
    password: my-db-password
    api_key: my-api-key
```

```nix
# In sops.nix
sops.secrets = {
  "database/password" = { ... };
  "database/api_key" = { ... };
};
```

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
