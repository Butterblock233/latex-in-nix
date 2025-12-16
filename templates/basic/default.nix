{
  pkgs ? import <nixpkgs> { },
}:

let
  pkgsConfig = import ./pkgs.nix { inherit pkgs; };
in
pkgs.stdenv.mkDerivation {
  name = "pdf";
  src = ./.;
  buildInputs = pkgsConfig.buildInputs;

  FONTCONFIG_FILE = pkgsConfig.fontConfig;

  preBuild = ''
    export HOME=$TMPDIR/home
    mkdir -p $HOME

    export XDG_CACHE_HOME=$TMPDIR/cache
    mkdir -p $XDG_CACHE_HOME/fontconfig

    export TEXINPUTS=".:$TEXINPUTS"


  '';

  buildPhase = ''
    mkdir -p .cache/latex

    # build LateX document
    latexmk -interaction=nonstopmode -auxdir=.cache/latex -xelatex main.tex

    # biber main
    # xelatex -interaction=nonstopmode main.tex
  '';

  installPhase = ''
    mkdir -p $out
    cp main.pdf $out
  '';
}
