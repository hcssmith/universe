{pkgs, ...}: {
  plugins.neogit = {
    enable = true;
    settings.integrations.telescope = true;
    package = pkgs.vimUtils.buildVimPlugin {
      name = "neogit-nightly";
      src = pkgs.fetchFromGitHub {
        owner = "NeogitOrg";
        repo = "neogit";
        rev = "023a515fa33904e140f3f20a83e6fb1c7b9ffffe";
        hash = "sha256-asQ4i03AYwyyMhaAUW9PmH9Kt6s+dBWiy5jv/UEYWQo=";
      };
    };
  };
  keymaps = [
    {
      action = "function () require('neogit').open() end";
      key = "<leader>ng";
      lua = true;
    }
  ];
}
