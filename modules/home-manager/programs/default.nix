{ pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./zsh.nix
    ./development.nix
    ./cli-tools.nix
  ];
}
