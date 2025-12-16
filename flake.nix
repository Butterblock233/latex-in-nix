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
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.callPackage ./default.nix { };
      }
    ))
    // {
      templates = {
        full = {
          path = ./.;
          description = "The default LaTeX template";
          welcomeText = ''
            # LaTeX Template initialized!
            Run `nix build` to compile the document.
          '';
        };
        basic = {
          path = ./templates/basic;
          description = "The default LaTeX template";
          welcomeText = ''
            # LaTeX Template initialized!
            Run `nix build` to compile the document.
          '';
        };
      };
    };
}
