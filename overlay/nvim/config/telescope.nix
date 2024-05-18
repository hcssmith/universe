{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = {action = "find_files";};
      "<leader>fb" = {action = "buffers";};
      "<leader>gf" = {action = "git_files";};
      "<leader>vh" = {action = "help_tags";};
    };
    extensions = {
      ui-select.enable = true;
    };
  };
  keymaps = [
    {
      action = ''function () require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") }) end'';
      lua = true;
      key = "<leader>ps";
    }
  ];
}
