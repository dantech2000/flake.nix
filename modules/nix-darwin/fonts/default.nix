{ config, pkgs, lib, ... }:

{
  # System-wide fonts installation
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
    nerd-fonts.fira-code
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
} 