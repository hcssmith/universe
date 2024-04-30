{
  pkgs,
  lib,
  ...
}: {
  plugins.cmp = {
    enable = true;
    settings = {
      snippet.expand = ''
        function(args)
          local luasnip = require('luasnip')
          luasnip.lsp_expand(args.body)
        end
      '';
      window.completion = {
        border = "none";
        col_offset = -4;
        side_padding = 1;
        winhighlight = "Normal:CmpNormal,CmpItemAbbr:CmpNormal,Search:None";
      };
      mapping = {
        "<C-b>" = "cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' })";
        "<C-f>" = "cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' })";
        "<CR>" = "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
        "<C-Space>" = "cmp.mapping.complete()";
        "<Down>" = "cmp.mapping.select_next_item()";
        "<Up>" = "cmp.mapping.select_prev_item()";
      };
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "luasnip";}
        {name = "buffer";}
        {name = "treesitter";}
      ];
      formatting = {
        fields = ["kind" "abbr" "menu"];
        format = lib.mkForce ''
          function(entry, vim_item)
                local kind = require('lspkind').cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item).kind or ' '
                vim_item.kind = ' ' .. kind .. ' '
                vim_item.menu = ({
                  nvim_lsp = '[Lsp]',
                  path = '[Path]',
                  buffer = '[Buf]',
                  luasnip = '[Snip]',
                  treesitter = '[Tree]'
                })[entry.source.name]
                return vim_item
              end
        '';
      };
    };
  };
  plugins = {
    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp_luasnip.enable = true;
    cmp-path.enable = true;
    cmp-treesitter.enable = true;
  };
}
