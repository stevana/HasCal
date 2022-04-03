{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, exceptions, hashable, lib
      , list-transformer, microlens-platform, mtl, prettyprinter
      , safe-exceptions, transformers, unordered-containers
      }:
      mkDerivation {
        pname = "HasCal";
        version = "1.0.0";
        src = ./.;
        libraryHaskellDepends = [
          base exceptions hashable list-transformer microlens-platform mtl
          prettyprinter safe-exceptions transformers unordered-containers
        ];
        description = "Haskell embedding of PlusCal";
        license = lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv