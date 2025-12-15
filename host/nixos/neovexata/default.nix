{ getModule, ... }:
{
  system = "x86_64-linux";
  modules = [

  ];
  users.hyloarch = {
    homeDirectory = "/home/hyloarch";
    homeModules = [
      (getModule /home-manager/vscode.nix)
    ];
  };
}
