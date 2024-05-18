{
  plugins.ccc = {
    enable = true;
    settings = {
      highlighter = {
        auto_enable = true;
      };
    };
  };
  keymaps = [
    {
      action = ":CccPick<CR>";
      key = "<leader>ccc";
      options = {
        silent = true;
      };
    }
  ];
}
