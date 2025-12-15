{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      kitty
      cargo
    ];
    fonts.packages = [
      pkgs.nerd-fonts.geist-mono
    ];

    nixpkgs.config.allowUnfree = true;

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      } // (if pkgs.stdenv.hostPlatform.isDarwin then {
        interval = {
          Hour = 4;
          Minute = 0;
          Day = 1;
        };
      } else {
        dates = "monthly";
      });
    };
  };
}
