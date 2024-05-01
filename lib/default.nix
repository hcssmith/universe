{
  supportedSystems,
  nixpkgs,
  overlays,
  inputs,
}: rec {
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

  nixpkgsFor = forAllSystems (
    system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays;
      }
  );

  genOverlay = {
    dir,
    prev,
  }:
    nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (
      name: prev.callPackage /${dir}/${name} {inherit prev inputs;}
    );

  fromDir = dir: final: prev: (genOverlay {
    dir = dir;
    prev = prev;
  });

  overlayToPackages = dir: pkgs:
    nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (
      name: pkgs.${name}
    );
}
