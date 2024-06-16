{prev, ...}: let
  lib = prev.lib;
in
  prev.stdenv.mkDerivation (finalAttrs: {
    pname = "prepare-system";
    version = "master";

    src = ./.;

    nativeBuildInputs = with prev; [
      makeWrapper
    ];

    installPhase = ''
      install -m755 ./prepare-system.sh -D $out/bin/prepare-system
      install -m555 ./root-on-tmpfs-template.nix -D $out/lib

      wrapProgram $out/bin/prepare-system --prefix PATH : ${lib.makeBinPath [prev.gum prev.xclip prev.git]}
    '';

    meta = {
      description = "Prepare a balnk system for nixos installation";
      homepage = "https://github.com/hcssmith/universe#prepare-system";
      license = lib.licenses.free;
      maintainers = with lib.maintainers; [hcssmith];
    };
  })
