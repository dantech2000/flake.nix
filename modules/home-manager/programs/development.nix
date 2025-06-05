{ pkgs, ... }:

{
  # Development packages
  home.packages = with pkgs; [
    # Languages and runtimes
    go
    bun
    rustup
    uv                # Python package installer

    # Development tools and workflow
    act               # GitHub Actions locally
    asdf-vm           # Version manager
    automake          # Build tool
    devbox            # Development environments
    devenv            # Development environments
    direnv            # Environment management
    gh                # GitHub CLI
    just              # Command runner
    go-task           # Task runner
    goreleaser        # Go release automation
    cookiecutter      # Project templates
    stow              # Symlink management

    # Cloud and DevOps tools
    awscli2           # AWS CLI
    (pkgs.wrapHelm pkgs.kubernetes-helm { plugins = [ pkgs.kubernetes-helmPlugins.helm-diff ]; })
    helmfile-wrapped  # Helm charts management
    k9s               # Kubernetes TUI
    kind              # Kubernetes in Docker
    krew              # kubectl plugin manager
    kubecolor         # Colorized kubectl
    kubectl           # Kubernetes CLI
    kubectx           # Kubernetes context switching
    stern             # Multi-pod log tailing

    # Infrastructure and automation
    ansible-lint      # Ansible linting
    packer            # Image building
    terraform-ls      # Terraform language server
    terraformer       # Terraform import tool
    tflint            # Terraform linting
    trivy             # Security scanner
    pinact            # GitHub Actions

    # Databases and data tools
    mongosh           # MongoDB shell
    redis             # Redis CLI
    redli             # Redis client
    sqlite            # SQLite

    # Package managers and tools
    pnpm              # Node package manager
    yarn              # Node package manager

    # Code quality and analysis
    shellcheck        # Shell script linting

    # Build and system tools
    unixODBC          # Database connectivity
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
      init = { defaultBranch = "trunk"; };
      diff = { external = "${pkgs.difftastic}/bin/difft"; };
    };
  };
} 