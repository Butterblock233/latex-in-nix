# pkgs.nix
{ pkgs }:

let
  fonts = with pkgs; [
    # add your extra fonts below
    corefonts
    source-han-serif
    source-han-sans
  ];
  # TexLive package is huge, so we combined TexLive basic packages with extra packages we need.
  # If you hate add package each time you need it, you can just edit sheme package to `scheme-full`. available schemes: scheme-mininal, scheme-basic, scheme-small, scheme-medium, scheme-full, etc.
  texlivePkgs = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      collection-latex
      collection-latexrecommended
      collection-latexextra
      collection-fontsrecommended
      collection-fontsextra
      collection-langenglish
      collection-langeuropean
      collection-langchinese
      collection-langjapanese

      latexmk
      biber
      # add your extra texlive packages before `;`

      ;
  };

  buildInputs = with pkgs; [
    texlivePkgs # combined TexLive packages
    python313Packages.pygments
    fontconfig
    fonts
    # add your extra packages below
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
