-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Prefer creating groups and assigning autocmds to groups, because it makes it easier to clear them
augroup("mygroup", { clear = true })

autocmd("Filetype", {
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - "o" -- Don't continue comments with o and O
  end,
  group = "mygroup",
})

autocmd("BufWritePost", {
  pattern = "**/lua/config/*.lua",
  callback = function()
    local filepath = vim.fn.expand("%")
    dofile(filepath)
    vim.notify("Configuration reloaded \n" .. filepath, nil)
  end,
  group = "mygroup",
  desc = "Reload config on save",
})
