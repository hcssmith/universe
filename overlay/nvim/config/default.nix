{
  pkgs,
  pkg,
  ...
}: {
  # Import all your configuration modules here
  imports = [
    ./cmp.nix
    ./colourscheme.nix
    # hopefully fixed by https://github.com/uga-rosa/ccc.nvim/issues/117
    #    ./colourpicker.nix
    ./git_worktree.nix
    ./gui.nix
    ./harpoon.nix
    ./highlights.nix
    ./lsp.nix
    ./lualine.nix
    ./luasnip.nix
    ./macro.nix
    ./neogit.nix
    ./neorg.nix
    ./noice.nix
    ./telescope.nix
    ./treesitter.nix
  ];
  config = {
    globals.mapleader = " ";
    colorscheme = pkgs.lib.mkForce "melange";
    opts = {
      number = true;
      scrolloff = 8;
      signcolumn = "yes";
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      wrap = false;
      swapfile = false;
      backup = false;
    };
    plugins = {
      nvim-tree.enable = true;
      gitsigns.enable = true;
      markdown-preview.enable = true;
    };
    extraPackages = with pkgs; [
      ripgrep
      fd
      fswatch
    ];
    #    package = pkg;
    withRuby = false;
    autoGroups = {
      UtilAutoCmds = {clear = true;};
    };
    autoCmd = [
      {
        desc = "Set correct filetype on non standard types.";
        event = "BufEnter";
        group = "UtilAutoCmds";
        pattern = ["*.nw"];
        callback = {
          __raw = ''
            function(ev)
              vim.bo[ev.buf].filetype = "tex"
            end
          '';
        };
      }
      {
        desc = "Enable wrap on certain filetypes";
        event = "BufEnter";
        group = "UtilAutoCmds";
        pattern = ["*.nw" "*.tex" "*.norg" "*.md" "*.txt"];
        callback = {
          __raw = ''
            function(ev)
              vim.bo[ev.buf].textwidth = 80
              vim.bo[ev.buf].wrapmargin = 80
              vim.cmd.setlocal('wrap')
            end
          '';
        };
      }
    ];
    keymaps = [
      {
        action = "<Esc>";
        key = "jk";
        mode = ["i"];
      }
      {
        action = "<C-\\><C-N>";
        key = "jk";
        mode = ["t"];
      }
      {
        action = "<C-W><C-h>";
        key = "<C-h>";
      }
      {
        action = "<C-W><C-j>";
        key = "<C-j>";
      }
      {
        action = "<C-W><C-k>";
        key = "<C-k>";
      }
      {
        action = "<C-W><C-l>";
        key = "<C-l>";
      }
      {
        action = "<C-W><C-h>";
        key = "<C-Left>";
      }
      {
        action = "<C-W><C-j>";
        key = "<C-Down>";
      }
      {
        action = "<C-W><C-k>";
        key = "<C-Up>";
      }
      {
        action = "<C-W><C-l>";
        key = "<C-Right>";
      }
      {
        action = ":cn<CR>";
        key = "]q";
        options.silent = true;
      }
      {
        action = ":cp<CR>";
        key = "[q";
        options.silent = true;
      }
      {
        action = ":clast<CR>";
        key = "[Q";
        options.silent = true;
      }
      {
        action = ":cfirst<CR>";
        key = "[Q";
        options.silent = true;
      }
      {
        action = ''
          function()
            local qf_exists = false
            for _, win in pairs(vim.fn.getwininfo()) do
              if win["quickfix"] == 1 then
                qf_exists = true
              end
            end
            if qf_exists == true then
              vim.cmd "cclose"
              return
            end
            if not vim.tbl_isempty(vim.fn.getqflist()) then
              vim.cmd "copen"
            end
          end
        '';
        lua = true;
        key = "<leader>qf";
      }
      {
        action = ":m '>+1<CR>gv=gv";
        key = "J";
        mode = ["v"];
        options.silent = true;
      }
      {
        action = ":m '>-2<CR>gv=gv";
        key = "K";
        mode = ["v"];
        options.silent = true;
      }
    ];
  };
}
