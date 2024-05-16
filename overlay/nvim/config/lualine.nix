{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    sections = {
			lualine_a = [
				{name = "require('NeoComposer.ui').status_recording()";}
				{name = "mode";}
			];
      lualine_c = [
        {name = "filename";}
        {name = "require('lspsaga.symbol.winbar').get_bar()";}
        {name = "require'lsp-status'.status()";}
      ];
    };
  };
}
