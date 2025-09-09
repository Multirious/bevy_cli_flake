{
  description = "Flake for the Bevy CLI and Linter";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bevy_cli = {
      url = "github:TheBevyFlock/bevy_cli/cli-v0.1.0-alpha.1";
      flake = false;
    };
    bevy_cli_linter = {
      url = "github:TheBevyFlock/bevy_cli/lint-v0.4.0";
      flake = false;
    };
  };
  outputs = { self, flake-utils, nixpkgs, rust-overlay, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        packages.bevy_cli = pkgs.callPackage ./bevy_cli.nix {
          srcInput = inputs.bevy_cli;
        };
        packages.bevy_lint =
          let
            nightlyRust = pkgs.rust-bin.nightly."2025-06-26".default.override {
              extensions = ["rustc-dev" "llvm-tools-preview"];
            };
            rustPlatform = pkgs.makeRustPlatform {
              cargo = nightlyRust;
              rustc = nightlyRust;
            };
          in
          pkgs.callPackage ./bevy_lint.nix {
            inherit rustPlatform;
            rust-bin = nightlyRust;
            srcInput = inputs.bevy_cli_linter;
          };
        packages.default = pkgs.symlinkJoin {
          name = "bevy_cli_and_linter";
          paths = [
            self.packages."${system}".bevy_cli
            self.packages."${system}".bevy_lint
          ];
        };
      }
    );
}
