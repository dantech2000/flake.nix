{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  # ZSH-related packages
  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-fzf-history-search
    zsh-fzf-tab
    zsh-syntax-highlighting
    carapace
    fzf
  ];

  # ZSH-related session variables
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --no-ignore-vcs";
    FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
    ZSH_COMPDUMP = "$HOME/.cache/zsh/.zcompdump";
  };

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        # Set umask
        umask 022
        # Suppress Powerlevel10k instant prompt errors
        typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
        # Powerlevel10k instant prompt (keep at the top for performance reasons)
        local username="''${USER:-$(whoami)}"
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${username}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${username}.zsh"
        fi
      '')
      (lib.mkIf isDarwin (lib.mkOrder 600 ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      ''))
      (lib.mkOrder 1200 ''
        # For Debugging (commented out by default)

        # set -x
        # ASDF Init (guarded)
        [ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"
        [ -f "$HOME/.asdf/completions/asdf.bash" ] && . "$HOME/.asdf/completions/asdf.bash"

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

        # Powerlevel10k theme from Nix package (correct path)
        source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
        if [ -f "$XDG_CONFIG_HOME/p10k/p10k.zsh" ]; then
          source "$XDG_CONFIG_HOME/p10k/p10k.zsh"
        fi

        # Add additional paths
        export PATH="$GOROOT/bin:$PATH"
        export PATH="$PATH:$GOPATH/bin"


        # Add Asdf shims
        export PATH="${"$"}{ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
      '')
      (lib.mkIf isDarwin (lib.mkOrder 1300 ''
        # Mac-specific paths
        export PATH="/usr/local/opt/llvm/bin/clangd:/Library/Frameworks/Python.framework/Versions/3.7/bin:$PATH"
        export PATH="/Applications/Windsurf.app/Contents/MacOS:$PATH"
        [ -e /usr/local/bin/windsurf ] || ln -s /Applications/Windsurf.app/Contents/MacOS/Electron /usr/local/bin/windsurf
      ''))
    ];

    shellAliases =
      {
        k = "kubectl";
        ls = "eza --icons=always";
        lss = "/bin/ls";
        tmux = "tmux -f ~/.config/tmux/tmux.conf";
        p = "ping google.com";
        shell = "vim $ZDOTDIR/.zshrc";
        profile = "vim $HOME/.zprofile";
        gpinit = "git push --set-upstream origin \"$(git symbolic-ref --short HEAD)\"";
      }
      // lib.optionalAttrs isDarwin {
        ll = "/usr/local/bin/lsd --long --group-dirs=first";
        lla = "/usr/local/bin/lsd --long --all --group-dirs=first";
        llt = "/usr/local/bin/lsd --tree --all";
        rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin";
      };

    oh-my-zsh = {
      enable = true;
      plugins =
        [
          "git"
          "kubectl"
          "colored-man-pages"
          "virtualenv"
          "terraform"
          "tmux"
          "docker"
          "ssh-agent"
        ]
        ++ lib.optionals isDarwin [
          "brew"
          "macos"
        ];
    };
  };

  # Powerlevel10k config managed by Nix
  xdg.configFile."p10k/p10k.zsh".source = ../config/p10k/p10k.zsh;

  # Starship Configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # XDG Configuration Files for starship
  xdg.configFile."starship/starship.toml".source = ../config/starship/starship.toml;
}
