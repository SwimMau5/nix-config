{
  description = "User home-manager flake";

  inputs = {
    nixpkgs.url = "github:swimmau5/nixpkgs/nixos-25.11";
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... }@inputs:
    let
      getModule = mod: ./mod + mod;
      systemTypes = {
        nixos = {
          system = inputs.nixpkgs.lib.nixosSystem;
          home-manager = inputs.home-manager.nixosModules.home-manager;
        };
        darwin = {
          system = inputs.darwin.lib.darwinSystem;
          home-manager = inputs.home-manager.darwinModules.home-manager;
        };
      };
      mkHost =
        type:
        host: fileType:
        if fileType == "directory" then
          let
            module = import ./host/${type}/${host};
            config = if builtins.isFunction module then
                module { inherit inputs getModule; }
              else module;
            mkUser =
              user: userConfig:
              {
                imports = (userConfig.homeModules or [ ]) ++ [
                  ({ lib, ... }: {
                    home = {
                      username = user;
                      homeDirectory = lib.mkForce userConfig.homeDirectory;
                    };
                  })
                  ./host/${type}/${host}/home.nix
                  ./mod/home-manager
                ];
              };
          in systemTypes.${type}.system {
            system = config.system;
            modules = (config.modules or [ ]) ++ [
              ./mod
              ./host/${type}/${host}/configuration.nix
              systemTypes.${type}.home-manager
              {
                networking.hostName = host;
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users = builtins.mapAttrs mkUser config.users;
                  backupFileExtension = "hm-bkup";
                };
              }
            ];
            specialArgs = { inherit inputs; } // (config.specialArgs or { });
          }
        else { };
    in {
      nixConfigurations = builtins.mapAttrs (mkHost "nixos") (builtins.readDir ./host/nixos);
      darwinConfigurations = builtins.mapAttrs (mkHost "darwin") (builtins.readDir ./host/darwin);
    };
}
