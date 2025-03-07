{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    act
    bat
    bun
    carapace
    cookiecutter
    coreutils-full
    curl
    devbox
    direnv
    eza
    fzf
    gh
    gnugrep
    gnupg
    go-task
    goreleaser
    hello
    htop
    jq
    just
    k9s
    ansible-lint
    asdf-vm
    automake
    awscli2
    coreutils-full
    dnsmasq
    ffmpeg_7
    findutils
    gnused
    helmfile-wrapped
    devenv
    go
    imagemagick
    jetbrains-mono
    just
    kind
    krew
    kubecolor
    kubectl
    kubectx
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    libheif
    libxslt
    monaspace
    mongosh
    neofetch
    packer
    pipenv
    pulumi-bin
    redis
    redli
    ripgrep
    shellcheck
    sshpass
    stern
    stow
    sqlite
    terraform-ls
    terraformer
    tflint
    time
    tldr
    tmux
    tree
    trivy
    unixODBC
    unzip
    wget
    yarn
    yq
    yt-dlp
    zlib
    zoxide
    zsh
    zsh-autosuggestions
    zsh-fzf-history-search
    zsh-fzf-tab
    zsh-syntax-highlighting
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
    GOPATH = "$HOME/go";
    FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --no-ignore-vcs";
    FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
    GPG_TTY = "$(tty)";
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
    STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml";

    # Additional environment variables
    XDG_CONFIG_HOME = "$HOME/.config";
    ZDOTDIR = "$HOME/.config/zsh";
    ZSH_COMPDUMP = "$HOME/.cache/zsh/.zcompdump";
    LC_ALL = "en_US.UTF-8";
    LESS = "-R";
    SSH_CONFIG_DIR = "$HOME/.config/ssh";
    PYTHONDONTWRITEBYTECODE = "1";
  };

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtraFirst = ''
      # Set umask
      umask 022
    '';

    initExtra = ''
      # For Debugging (commented out by default)
      # set -x

      # Set variable for current user
      local username="''${USER:-$(whoami)}"

      # History and completion settings
      setopt autocd interactive_comments INC_APPEND_HISTORY
      autoload -Uz compinit
      compinit -C

      # Vi mode settings and key bindings
      bindkey '^R' history-incremental-search-backward
      bindkey -v

      # Kubectl completion
      source <(kubectl completion zsh)

      # Carapace completion
      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)
      zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

      # Add additional paths
      export PATH="/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
      export PATH="/usr/local/opt/llvm/bin/clangd:/Library/Frameworks/Python.framework/Versions/3.7/bin:$PATH"
      export PATH="$GOROOT/bin:$PATH"
      export PATH="$PATH:$GOPATH/bin"
    '';

    shellAliases = {
      k = "kubectl";
      ls = "eza --icons=always";
      lss = "/bin/ls";
      tmux = "tmux -f ~/.config/tmux/tmux.conf";
      p = "ping google.com";
      ll = "/usr/local/bin/lsd --long --group-dirs=first";
      lla = "/usr/local/bin/lsd --long --all --group-dirs=first";
      llt = "/usr/local/bin/lsd --tree --all";
      shell = "vim $ZDOTDIR/.zshrc";
      profile = "vim $HOME/.zprofile";
      gpinit = "git push --set-upstream origin \"$(git symbolic-ref --short HEAD)\"";
      rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "brew"
        "macos"
        "colored-man-pages"
        "virtualenv"
        "terraform"
        "tmux"
        "docker"
        "ssh-agent"
      ];
    };
  };

  # Starship Configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # XDG Configuration Files
  xdg.configFile."starship/starship.toml".source = ./config/starship.toml;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # OS Configurations
  targets.darwin.defaults = lib.mkIf pkgs.stdenv.isDarwin {
    "com.apple.desktopservices".DSDontWriteNetworkStores = true;
  };
}
