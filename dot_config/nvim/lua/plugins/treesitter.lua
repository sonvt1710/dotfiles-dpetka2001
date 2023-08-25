return {
  -- Modify Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- Add nvim-ts-autotag
      { "windwp/nvim-ts-autotag" },

      -- Modify nvim-ts-context-commentstring
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    -- event = { "BufReadPre" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "fish",
        "rust",
      })
      return vim.tbl_deep_extend("force", opts, {
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
        autotag = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
          config = {
            c = { __default = "// %s", __multiline = "/* %s */" },
            cpp = { __default = "// %s", __multiline = "/* %s */" },
          },
        },
      })
    end,
  },

  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    keys = {
      { "<leader>uth", "<cmd>TSHighlightCapturesUnderCursor<cr>", desc = "Show highlight groups under the cursor" },
      { "<leader>utn", "<cmd>TSNodeUnderCursor<cr>", desc = "Show node under the cursor" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    opts = { mode = "cursor" },
    keys = {
      {
        "[C",
        function()
          require("treesitter-context").go_to_context()
        end,
        silent = true,
        desc = "Go to Context",
      },
    },
  },
}
