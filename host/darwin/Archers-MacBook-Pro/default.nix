{ getModule, ... }:
{
  system = "aarch64-darwin";
  modules = [
    # (getModule /test.nix)
    (getModule /pixieditor.nix)
  ];
  # specialArgs = {};
  users.amatthias = {
    homeDirectory = "/Users/amatthias";
    homeModules = [
      (getModule /home-manager/packwiz.nix)
    ];
  };
}
