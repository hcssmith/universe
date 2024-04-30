{
  prev,
  inputs,
  ...
}:
inputs.nixvim.legacyPackages.${prev.system}.makeNixvimWithModule {
  module = import ./config;
  extraSpecialArgs = {
    notes_dir = "~/notes/";
    wrap_files = ["*.nw" "*.tex" "*.norg" "*.md" "*.txt"];
		pkg = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
		pkgs_stable = inputs.nixpkgs_stable.legacyPackages.${prev.system};
  };
}
