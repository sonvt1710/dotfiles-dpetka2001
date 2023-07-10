local util = require("util")

return {
  -- Add ``lang`` to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      util.list_insert_unique(opts.ensure_installed, {
        "css",
        "php",
      })
    end,
  },

  -- Add ``server`` and ``formatter`` to mason
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        --[[Servers]]
        --[[Formatters]]
        "prettierd",
        -- "prettier",
      })
    end,
  },

  -- Setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        cssls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        stylelint_lsp = {}, -- css linter
        eslint = {},
        intelephense = {},
        emmet_language_server = {},
      },
      setup = {
        tsserver = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
            end
            -- if client.name == "eslint" then
            --   client.server_capabilities.documentFormattingProvider = true
            -- end
          end)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },

  -- Setup null-ls with `prettierd`
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.formatting.prettierd,
        nls.builtins.code_actions.eslint,
        -- nls.builtins.formatting.prettierd.with({
        --   filetypes = { "html", "css", "json", "jsonc", "yaml", "markdown" },
        -- }),
      })
    end,
  },
}
