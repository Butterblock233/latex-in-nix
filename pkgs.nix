# pkgs.nix
{ pkgs }:

let
  fonts = with pkgs; [
    corefonts
    noto-fonts-cjk-serif-static
    source-han-serif
    source-han-sans
    jetbrains-mono
  ];

  texlivePkgs = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-full
      latexmk
      biblatex
      xetex
      biber
      fontspec
      ctex
      everypage
      titlesec
      tcolorbox
      eso-pic
      fancyhdr
      mdframed
      tikzfill
      pdfcol
      fandol
      minted
      ;
  };

  buildInputs = with pkgs; [
    texlivePkgs
    python313Packages.pygments
    fontconfig
    fonts
  ];

  fontConfig = pkgs.makeFontsConf { fontDirectories = fonts; };
in
{
  inherit
    fonts
    texlivePkgs
    buildInputs
    fontConfig
    ;
}
