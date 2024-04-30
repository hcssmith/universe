{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = {action = "find_files";};
      "<leader>fb" = {action = "buffers";};
      "<leader>gf" = {action = "git_files";};
      "<leader>vh" = {action = "help_tags";};
      "<leader>ps" = {action = "grep_string";};
    };
    extensions = {
      ui-select.enable = true;
    };
  };
}
