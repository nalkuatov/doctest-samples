{
  haskellNix ? import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/b0d03596f974131ab64d718b98e16f0be052d852.tar.gz") {}
, nixpkgsSrc ? haskellNix.sources.nixpkgs-2009
, nixpkgsArgs ? haskellNix.nixpkgsArgs
, pkgs ? import nixpkgsSrc nixpkgsArgs
}: rec {

  hs-pkgs = with pkgs.haskell-nix; stackProject {
    src = haskellLib.cleanGit {
      src = ./.;
    };
    modules = [{
      doHaddock = false;
    }];
  };

  cabal-docspec = pkgs.stdenv.mkDerivation rec {
    name = "cabal-docspec";
    src = builtins.fetchurl {
      url = "https://github.com/phadej/cabal-extras/releases/download/cabal-docspec-0.0.0.20210111/cabal-docspec-0.0.0.20210111.xz";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      xz -d < ${src} > $out/bin/cabal-docspec
      chmod +x $out/bin/cabal-docspec
    '';
  };

  run-doctests =
    let
      env = hs-pkgs.shellFor {
        withHaddock = false;
        additional = _: [ hs-pkgs.doctest-samples.components.library ];
      };
    in
    pkgs.writeShellScript "run-doctests" ''
        export PATH="${pkgs.lib.makeBinPath [ env.ghc cabal-docspec ] }"
        cabal-docspec --no-cabal-plan doctest-samples.cabal
    '';
}
