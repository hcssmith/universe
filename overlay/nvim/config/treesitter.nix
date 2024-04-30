{
  plugins.treesitter = {
    enable = true;
    folding = true;
    indent = true;
    disabledLanguages = ["make"];
    nixvimInjections = true;
  };
  plugins.treesitter-textobjects = {
    enable = true;
    lspInterop = {
      enable = true;
      peekDefinitionCode = {
        "<leader>df".query = "@function.outer";
        "<leader>dF".query = "@class.outer";
      };
    };
    select = {
      enable = true;
      lookahead = true;
      selectionModes = {
        "@parameter.inner" = "v";
        "@function.outer" = "V";
        "@function.inner" = "V";
      };
      keymaps = {
        "a=".query = "@assignment.outer";
        "i=".query = "@assignment.inner";
        "l=".query = "@assignment.lhs";
        "r=".query = "@assignment.rhs";
        "af".query = "@function.outer";
        "if".query = "@function.inner";
        "ip".query = "@parameter.inner";
        "ab".query = "@block.outer";
        "ib".query = "@block.inner";
      };
    };
  };
}
