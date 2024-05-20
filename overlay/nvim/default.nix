{
  prev,
  inputs,
  ...
}:
inputs.nixvim.legacyPackages.${prev.system}.makeNixvimWithModule {
  module = import ./config;
  extraSpecialArgs = {
    pkg = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
    pkgs_stable = inputs.nixpkgs_stable.legacyPackages.${prev.system};
  };
}
