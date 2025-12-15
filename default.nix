{
  pkgs ? import <nixpkgs> { },
  ...
}:

let
  fonts = with pkgs; [
    source-han-serif
    source-han-sans
    jetbrains-mono

  ];
in
pkgs.stdenv.mkDerivation {
  name = "pdf";
  src = ./.;
  buildInputs = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        latexmk
        scheme-basic
        biblatex
        xetex
        biber
        fontspec
        ctex
        enumitem
        amsmath
        geometry
        xcolor
        listings
        chemfig
        simplekv
        mhchem
        minted
        upquote
        lineno
        ;
      jetbrainsmono-otf = pkgs.texlivePackages.jetbrainsmono-otf;
    })
    python313Packages.pygments
    fontconfig
	    fonts
  ];

  FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = fonts; };
  buildPhase = ''
    mkdir -p .cache/latex
    latexmk -interaction=nonstopmode -auxdir=.cache/latex -xelatex main.tex
  '';
  installPhase = ''
    mkdir -p $out
    cp main.pdf $out
  '';
}
