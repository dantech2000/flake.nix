{ config, pkgs, ... }:

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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.act
    pkgs.bat
    pkgs.cookiecutter
    pkgs.coreutils-full
    pkgs.curl
    pkgs.direnv
    pkgs.eza
    pkgs.fzf
    pkgs.gh
    pkgs.gnugrep
    pkgs.gnupg
    pkgs.go-task
    pkgs.hello
    pkgs.htop
    pkgs.jq
    pkgs.just
    pkgs.k9s
    pkgs.kubecolor
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.neofetch
    pkgs.neovim
    pkgs.packer
    pkgs.pulumi-bin
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.tflint
    pkgs.tmux
    pkgs.wget
    pkgs.yt-dlp
    pkgs.zoxide
    pkgs.stow

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # OS Configurations
  targets.darwin.defaults."com.apple.finder".ShowStatusBar = true;
  targets.darwin.defaults."com.apple.finder".AppleShowAllFiles = true;
  targets.darwin.defaults."com.apple.dock".autohide = true;
  targets.darwin.defaults."com.apple.desktopservices".DSDontWriteNetworkStores = true;
}
