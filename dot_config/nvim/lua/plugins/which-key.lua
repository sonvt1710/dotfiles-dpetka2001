return {
  -- Modify which-key keys
  {
    "folke/which-key.nvim",
    opts = function()
      require("which-key").register({
        ["<leader>xl"] = {
          name = "+LSP (Telescope)",
        },
        ["<leader>un"] = {
          name = "+Notifications",
        },
        ["<leader>ut"] = {
          name = "+Treesitter",
        },
        ["zd"] = { "Delete fold under cursor" },
        ["zD"] = { "Delete folds recursively under cursor" },
        ["zE"] = { "Eliminate all folds in window" },
      })
    end,
  },
}
