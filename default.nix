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

  # 确保 texlive 能找到字体
  FONTCONFIG_FILE = pkgsConfig.fontConfig;

  # 设置可写的缓存目录
  preBuild = ''
    # 在沙盒环境中设置可写目录
    export HOME=$TMPDIR/home
    mkdir -p $HOME

    # 设置字体缓存目录
    export XDG_CACHE_HOME=$TMPDIR/cache
    mkdir -p $XDG_CACHE_HOME/fontconfig

    # 设置 LaTeX 搜索路径，包含当前目录
    export TEXINPUTS=".:$TEXINPUTS"


  '';

  buildPhase = ''
    # 创建缓存目录
    mkdir -p .cache/latex

    # 使用 xelatex 构建
    latexmk -interaction=nonstopmode -auxdir=.cache/latex -xelatex main.tex

    # 如果需要 biber 处理参考文献，取消下面两行的注释：
    # biber main
    # xelatex -interaction=nonstopmode main.tex
  '';

  installPhase = ''
    mkdir -p $out
    cp main.pdf $out
  '';
}
