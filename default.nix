{
  haskellNix ? import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/b0d03596f974131ab64d718b98e16f0be052d852.tar.gz") {}
, nixpkgsSrc ? haskellNix.sources.nixpkgs-2009
, nixpkgsArgs ? haskellNix.nixpkgsArgs
, pkgs ? import nixpkgsSrc nixpkgsArgs
}: rec {

  pkgsStatic = pkgs.pkgsCross.musl64;

  src = pkgsStatic.haskell-nix.haskellLib.cleanGit {
    name = "doctest-samples";
    src = ./.;
  };

  hs-pkgs = with pkgsStatic.haskell-nix; stackProject {
    src = src;
    modules = [{
      doHaddock = false;
    }];
  };

  cabal-docspec = pkgs.stdenv.mkDerivation rec {
    name = "cabal-docspec";
    src = builtins.fetchurl {
      url = "https://github.com/phadej/cabal-extras/releases/download/cabal-docspec-0.0.0.20210111/cabal-docspec-0.0.0.20210111.xz";
    };
    phases = [ "installPhase" "fixupPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      xz -d < ${src} > cabal-docspec
      install -m755 -D cabal-docspec $out/bin/cabal-docspec
    '';
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];
    buildInputs = [
      pkgs.gmp
    ];
  };

  run-doctests = { target ? "doctest-samples" }:
    let
      env = hs-pkgs.shellFor {
        withHoogle = false;
        additional = _: [ hs-pkgs."${target}".components.library ];
      };
    in with pkgs; writeShellScript "run-doctests" ''
      export PATH=${lib.makeBinPath [ cabal-docspec env.ghc ] }
      cabal-docspec -w ${env.ghc.targetPrefix}ghc --no-cabal-plan ${src}/${target}.cabal
    '';
}
