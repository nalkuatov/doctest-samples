echo "installing cabal-docspec"
curl -sL https://github.com/phadej/cabal-extras/releases/download/cabal-docspec-0.0.0.20211114/cabal-docspec-0.0.0.20211114.xz > cabal-docspec.xz
xz -d < cabal-docspec.xz > "$HOME"/.cabal/bin/cabal-docspec
rm -f cabal-docspec.xz
chmod a+x "$HOME"/.cabal/bin/cabal-docspec
cabal-docspec --version
