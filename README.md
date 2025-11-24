# nix-config

Basic Nix configuration used on my devices. 

`flake.nix` will automatically build each configuration based on the contents of the `host` folder, with NixOS machines under `host/nixos` and Darwin machines under `host/darwin`. With the name of the folder as the host name, the contents are as follows:
- `configuration.nix`: Nix configurations used in nix modules.
- `home.nix`: Home-Manager configurations used in home-manager modules.
- `host.nix`: General configurations used to initialize the system.

## `host.nix` Attributes
- `username`: String value containing the name of the user.
- `homeDirectory`: String value containing the absolute path of the user's home directory.
- `modules`: List of paths to nix modules.
- `homeModules`: List of paths to home-manager modules.
- `specialArgs`: Attribute list of additional arguments to be passed to modules.

To simplify specifying paths to modules, the `getModule` helper function is passed to `host.nix`. This function takes a path relative to the `/mod` folder and returns the module path.
