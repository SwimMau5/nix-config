{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.hyloarch = {
      userSettings = {
        terminal.integrated.defaultProfile.linux = "zsh";
      };
      extensions = [
        pkgs.vscode-extensions.bbenoist.nix
      ];
    };
  };
}