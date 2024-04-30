{
  plugins.friendly-snippets.enable = true;
  plugins.luasnip = {
    enable = true;
    fromLua = [
      {
        paths = ../snippets;
      }
    ];
    fromVscode = [
      {}
    ];
    extraConfig = {
      history = true;
      updateevents = "TextChanged,TextChangedI";
    };
  };
  keymaps = [
    {
      action = ''
        function()
          local ls = require('luasnip')
          if ls.jumpable(1) then
            ls.jump(1)
          end
        end
      '';
      lua = true;
      key = "<C-j>";
      mode = ["i" "s"];
    }
    {
      action = ''
        function()
          local ls = require('luasnip')
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end
      '';
      lua = true;
      key = "<C-k>";
      mode = ["i" "s"];
    }
    {
      action = ''
        function()
          local ls = require('luasnip')
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end
      '';
      lua = true;
      key = "<C-c>";
      mode = ["i" "s"];
    }
  ];
}
