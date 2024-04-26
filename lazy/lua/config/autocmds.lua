-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_user_command("LinterInfo", function()
	local runningLinters = table.concat(require("lint").get_running(), "\n")
	vim.notify(runningLinters, vim.log.levels.INFO, { title = "nvim-lint" })
end, {})
