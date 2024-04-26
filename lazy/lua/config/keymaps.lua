-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<leader>pt", "<cmd>pu=expand('%:p')<cr>", { desc = "Print current full path" })
vim.api.nvim_set_keymap('n', '<leader>ee', [[:lua vim.diagnostic.open_float()<CR>]],
  { noremap = true, silent = true, desc = "Display full error" })
  
