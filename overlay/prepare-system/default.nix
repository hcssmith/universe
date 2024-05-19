{prev, ...}: let
  lib = prev.lib;
in
  prev.stdenv.mkDerivation (finalAttrs: {
    pname = "prepare-system";
    version = "master";

    src = ./.;

    nativeBuildInputs = with prev; [
      gum
      git
      xclip
    ];

    buildPhases = ["installPhase"];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib
      install -m 777 ./prepare-system.sh $out/bin/prepare-system
      install -m 555 ./root-on-tmpfs-template.nix $out/lib
    '';

    meta = {
      description = "Prepare a balnk system for nixos installation";
      homepage = "https://github.com/hcssmith/universe#prepare-system";
      license = lib.licenses.free;
      maintainers = with lib.maintainers; [hcssmith];
    };
  })
