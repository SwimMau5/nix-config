{
  description = "User home-manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... }@inputs: with import ./util.nix inputs; {
    nixConfigurations = builtins.mapAttrs (mkHost "nixos") (builtins.readDir ./host/nixos);
    darwinConfigurations = builtins.mapAttrs (mkHost "darwin") (builtins.readDir ./host/darwin);
  };
}
