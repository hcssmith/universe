{
  plugins.git-worktree = {
    enable = true;
    enableTelescope = true;
  };
  keymaps = [
    {
      action = "function () require('telescope').extensions.git_worktree.create_git_worktree() end";
      lua = true;
      key = "<leader>gwc";
    }
    {
      action = "function () require('telescope').extensions.git_worktree.git_worktrees() end";
      lua = true;
      key = "<leader>gwl";
    }
  ];
}
