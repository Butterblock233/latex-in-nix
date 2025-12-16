{
  description = "A simple LaTeX template for writing documents with latexmk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        pkgsConfig = import ./pkgs.nix { inherit pkgs; };
      in
      {
        packages.default = pkgs.callPackage ./default.nix { inherit pkgs; };

        devShells.default = pkgs.mkShell {
          packages = pkgsConfig.buildInputs;
          FONTCONFIG_FILE = pkgsConfig.fontConfig;
          shellHook = ''
            export TEXINPUTS=".:$TEXINPUTS"
            echo "LaTeX Environment is ready"
          '';
        };
      }
    );
}
