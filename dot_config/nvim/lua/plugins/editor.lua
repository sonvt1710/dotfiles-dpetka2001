local function diag_jump()
  -- More advanced example that also highlights diagnostics:
  require("flash").jump({
    matcher = function(win)
      ---@param diag Diagnostic
      return vim.tbl_map(function(diag)
        return {
          pos = { diag.lnum + 1, diag.col },
          end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
        }
      end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
    end,
    action = function(match, state)
      vim.api.nvim_win_call(match.win, function()
        vim.api.nvim_win_set_cursor(match.win, match.pos)
        vim.diagnostic.open_float()
      end)
      state:restore()
    end,
  })
end

return {
  -- Change default permissions for files created via Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        window = {
          mappings = {
            ["L"] = "open_nofocus",
          },
        },
        commands = {
          open_nofocus = function(state)
            require("neo-tree.sources.filesystem.commands").open(state)
            vim.schedule(function()
              vim.cmd([[Neotree focus]])
            end)
          end,
        },
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
      event_handlers = {
        {
          event = "file_added",
          handler = function(destination)
            local uv = vim.loop
            local file_info = uv.fs_stat(destination)
            if not file_info then
              return
            elseif file_info.type == "file" then
              uv.fs_chmod(destination, 436) -- (436 base 10) == (664 base 8)
            elseif file_info.type == "directory" then
              uv.fs_chmod(destination, 509) -- 644 does not work for directories I guess?
            end
          end,
        },
      },
    },
  },

  -- Modify gitsigns
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        map("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle Blame Line")
      end,
    },
  },

  -- Modify todo-comments
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        keyword = "bg",
        -- add extra pattern for `KEYWORD(AUTHOR):`
        pattern = { [[.*<(KEYWORDS)\s*:]], [[.*<(KEYWORDS)\s*[(][^)]*[)]:]] },
      },
    },
  },

  -- Modify `flash.nvim`
  {
    "folke/flash.nvim",
    keys = {
      -- Disable default mappings, cuz they conflict with `vim-surround`
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      {
        "m",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "M",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "]f",
        diag_jump,
        desc = "Flash diagnostic at chosen target",
      },
    },
    opts = {
      modes = {
        -- Disable labels for regular search with `/`
        search = {
          enabled = false,
        },
        -- Modify options used by `flash` when doing `f`, `F`, `t`, `T` motions
        char = {
          -- when to show jump labels
          jump_labels = function(motion)
            -- never show jump labels by default
            -- return false
            -- Always show jump labels for ftFT
            return vim.v.count == 0 and motion:find("[ftFT]")
            -- Show jump labels for ftFT in operator-pending mode
            -- return vim.v.count == 0 and motion:find("[ftFT]") and vim.fn.mode(true):find("o")
          end,
        },
      },
    },
  },

  -- Try out `fzf-lua`
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = {},
  },
}
