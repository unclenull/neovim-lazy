vim.opt.backup = false
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.cinoptions:append { 'j1', 'J1' }
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.exrc = true
vim.opt.wrap = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.cmd [[ autocmd BufEnter * silent! lcd %:p:h ]]

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
