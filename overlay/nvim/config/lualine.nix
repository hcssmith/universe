{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    sections = {
      lualine_c = [
        {name = "filename";}
        {name = "require('lspsaga.symbol.winbar').get_bar()";}
        {name = "require'lsp-status'.status()";}
      ];
    };
  };
}
