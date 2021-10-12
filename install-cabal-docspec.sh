git clone https://github.com/phadej/cabal-extras
cd cabal-extras
grep -v with-compiler cabal.project > cabal.project.out
mv cabal.project.out cabal.project
cd cabal-docspec
cabal install cabal-docspec
rm -rf cabal-extras
