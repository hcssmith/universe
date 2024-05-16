{pkgs, ...}: {
  extraPackages = with pkgs; [
    sqlite
  ];
  extraPlugins = with pkgs; [
    vimPlugins.sqlite-lua
    (vimUtils.buildVimPlugin {
      name = "neocomposor";
      src = fetchFromGitHub {
        owner = "ecthelionvi";
        repo = "NeoComposer.nvim";
        rev = "b06e8e88e289947937f241f76e86f7c46f4a5805";
        hash = "sha256-AQU+Z7iC7AMm17k7gw7dA0TEmImpJJhZ2rPk8zReJFg=";
      };
    })
  ];
  extraConfigVim = ''
    let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
  '';
  extraConfigLua = ''
    require("NeoComposer").setup()
    require('telescope').load_extension('macros')
  '';
  keymaps = [
    {
      action = ''
        function() require('NeoComposer.telescope.macros').show_macros() end
      '';
      lua = true;
      key = "<leader>m";
    }
  ];
}
