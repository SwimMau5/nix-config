inputs:
rec {
  getModule = mod: ./mod + mod;
  mkNixOSHost =
    host:
    fileType:
    if fileType == "directory" then
      let config = import ./host/nixos/${host}/host.nix getModule;
      in inputs.nixpkgs.lib.nixosSystem {
        system = config.system;
        modules = (config.modules or [ ]) ++ [
          ({ ... }: {
            networking.hostName = host;
          })
          ./mod
          ./host/nixos/${host}/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${config.username} = {
                imports = (config.homeModules or [ ]) ++ [
                  ({ ... }: {
                    home = {
                      username = config.username;
                      homeDirectory = config.homeDirectory;
                    };
                  })
                  ./host/nixos/${host}/home.nix
                  ./mod/home-manager
                ];
              };
              backupFileExtension = "hm-bkup";
            };
          }
        ];
        specialArgs = { inherit inputs; } // (config.specialArgs or { });
      }
    else { };
  mkDarwinHost =
    host:
    fileType:
    if fileType == "directory" then
      let config = import ./host/darwin/${host}/host.nix getModule;
      in inputs.darwin.lib.darwinSystem {
        system = config.system;
        modules = (config.modules or [ ]) ++ [
          ({ ... }: {
            networking.hostName = host;
          })
          ./mod
          ./host/darwin/${host}/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${config.username} = {
                imports = (config.homeModules or [ ]) ++ [
                  ({ lib, ... }: {
                    home = {
                      username = config.username;
                      homeDirectory = lib.mkForce config.homeDirectory;
                    };
                  })
                  ./host/darwin/${host}/home.nix
                  ./mod/home-manager
                ];
              };
              backupFileExtension = "hm-bkup";
            };
          }
        ];
        specialArgs = { inherit inputs; } // (config.specialArgs or { });
      }
    else { };
}
