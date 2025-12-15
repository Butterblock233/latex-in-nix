{
  pkgs ? import <nixpkgs> { },
  ...
}:

let
  fonts = with pkgs; [
    source-han-serif
    source-han-sans
    jetbrains-mono
    liberation_ttf
  ];
in
pkgs.stdenv.mkDerivation {
  name = "pdf";
  src = ./.;
  buildInputs = with pkgs; [
    # 为了节省磁盘空间使用了基础texlive加上自定义包
    # 在最底部添加新包重新nix build即可
    # 如果觉得过于繁琐可以把整个(texlive.combine .....)换成texliveFull
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
        # add your custom package here
        ;
    })
    python313Packages.pygments
    fontconfig
    fonts
  ];
  # ensure texlive can find fonts
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
