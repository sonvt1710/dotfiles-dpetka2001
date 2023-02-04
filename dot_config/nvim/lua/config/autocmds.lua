-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local util = require("lazyvim.util")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

--[[ Auto Commands ]]

-- Prefer creating groups and assigning autocmds to groups, because it makes it easier to clear them
augroup("mygroup", { clear = true })

autocmd("Filetype", {
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - "o" -- Don't continue comments with o and O
  end,
  group = "mygroup",
  desc = "Don't continue comments with o and O",
})

autocmd("Filetype", {
  pattern = { "*" },
  callback = function()
    local comment_ft = require("Comment.ft")
    comment_ft.set("lua", { "--%s", "--[[%s]]" })
  end,
  group = "mygroup",
  desc = "Set line/block type comments for Lua",
})

autocmd("BufWritePost", {
  -- Match all `lua` files in `lua/config` except `lazy.lua` which is the
  -- setup file for `lazy.nvim` and doesn't support reloading
  pattern = "**/lua/config/*[^lazy].lua",
  callback = function()
    local filepath = vim.fn.expand("%")
    dofile(filepath)
    vim.notify("Configuration reloaded \n" .. filepath, nil)
  end,
  group = "mygroup",
  desc = "Reload config on save",
})

--[[ User Commands ]]

usercmd("Rwd", function()
  print(util.get_root())
end, { desc = "Print root_dir of current buffer" })
