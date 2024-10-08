# My Nix Configuration

This repository contains my personal Nix configuration for macOS, using nix-darwin and Home Manager.

## Prerequisites

-   macOS
-   Command Line Tools for Xcode (can be installed by running `xcode-select --install` in the terminal)

## Installation

### 1. Install Nix

First, install Nix by running the following command in your terminal:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

### 2. Install nix-darwin

To install nix-darwin, run the following commands:

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

Follow the prompts to complete the installation.

### 3. Install Home Manager

Home Manager can be installed as part of the nix-darwin configuration. We'll include it in the `flake.nix` file, so there's no need for a separate installation step.

### 4. Clone this repository

Clone this repository to your local machine:

```bash
git clone https://github.com/dantech2000/flake.nix.git
cd flake.nix
```

### 5. Apply the configuration

To apply the configuration, run:

```bash
darwin-rebuild switch --flake .
```

This will apply the configuration and install the necessary packages.

This command will build and activate the nix-darwin configuration defined in the `flake.nix` file.

## Updating

To update your system with the latest changes from this repository:

1. Pull the latest changes:

    ```bash
    git pull origin main
    ```

2. Rebuild the system:
    ```bash
    darwin-rebuild switch --flake .
    ```

## Customization

To customize this configuration for your own use:

1. Edit the `flake.nix` file to change system-wide settings.
2. Modify the files in the `modules` directory to adjust specific configurations.
3. Update the `home.nix` file (if present) to change user-specific settings.

After making changes, rebuild the system using the command in the "Updating" section.

## Troubleshooting

If you encounter any issues during installation or usage, please check the following:

-   Ensure Nix is properly installed and sourced in your shell.
-   Verify that you have the latest version of nix-darwin and Home Manager.
-   Check the Nix, nix-darwin, and Home Manager documentation for known issues or solutions.

If problems persist, feel free to open an issue in this repository.
