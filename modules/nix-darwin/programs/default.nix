{ pkgs, config, ... }:

{
  # System packages installed in system profile
  environment.systemPackages = [
    pkgs.aws-sam-cli
    pkgs.vim
    pkgs.starship
    pkgs.mkalias
    pkgs.nixpkgs-fmt
    pkgs.gitAndTools.gitFull
  ];

  # System-level ZSH configuration
  programs.zsh = {
    enable = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    enableBashCompletion = true;
    variables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

  # Application setup for macOS
  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
}
