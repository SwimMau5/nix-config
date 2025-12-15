{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-tree
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {

      } // (if pkgs.stdenv.hostPlatform.isDarwin then {
        snrds = "sudo nix run nix-darwin -- switch --flake ~/dotfiles";
      } else {
        snrbs = "sudo nixos-rebuild switch";
      });
      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
      };
    };
    kitty = {
      enable = true;
      font = {
        name = "GeistMono Nerd Font Mono";
        size = 16;
      };
      themeFile = "OneDark-Pro";
    };
    btop.enable = true;
    home-manager.enable = true;
  };
}
