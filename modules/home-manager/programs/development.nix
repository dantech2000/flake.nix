{pkgs, ...}: {
  # Development packages
  home.packages = with pkgs; [
    # Languages and runtimes
    go
    bun
    rustup
    uv # Python package installer

    # Development tools and workflow
    act # GitHub Actions locally
    asdf-vm # Version manager
    automake # Build tool
    devbox # Development environments
    devenv # Development environments
    direnv # Environment management
    gh # GitHub CLI
    just # Command runner
    go-task # Task runner
    goreleaser # Go release automation
    cookiecutter # Project templates
    stow # Symlink management

    # Cloud and DevOps tools
    k9s # Kubernetes TUI
    kind # Kubernetes in Docker
    krew # kubectl plugin manager
    kubecolor # Colorized kubectl
    kubectl # Kubernetes CLI
    kubectx # Kubernetes context switching
    stern # Multi-pod log tailing
    kustomize_4 # Kubernetes configuration management

    # Infrastructure and automation
    # ansible-lint # Ansible linting (temporarily disabled due to ncclient hash mismatch in unstable)
    packer # Image building
    terraform-ls # Terraform language server
    terraformer # Terraform import tool
    tflint # Terraform linting
    trivy # Security scanner
    pinact # GitHub Actions

    # Databases and data tools
    mongosh # MongoDB shell
    nixd # Nix package manager
    redis # Redis CLI
    redli # Redis client
    sqlite # SQLite

    # Package managers and tools
    pnpm # Node package manager
    yarn # Node package manager

    # AI Tools
    claude-code
    codex

    # Code quality and analysis
    shellcheck # Shell script linting

    # Build and system tools
    unixODBC # Database connectivity
  ];

  # Development-specific session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    GOPATH = "$HOME/go";
    PYTHONDONTWRITEBYTECODE = "1";
  };

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "Daniel Rodriguez";
    userEmail = "drodriguez@codecademy.com";
    extraConfig = {
      github.user = "dantech2000";
      init = {
        defaultBranch = "main";
      };
      diff = {
        external = "${pkgs.difftastic}/bin/difft";
      };
      pull = {
        rebase = true;
      };
    };
  };
}
