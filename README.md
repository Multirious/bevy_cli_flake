# bevy_cli_flake

This is my flake rendition of the Bevy CLI with support for linter.

# devshells
```nix
{
  description = "A devShell example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bevy_cli_flake = {
      url = "github:Multirious/bevy_cli_flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            inputs.bevy_cli_flake.packages."${system}".default
          ];
        };
      }
    );
}
```
