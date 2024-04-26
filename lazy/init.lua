-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd [[ autocmd BufEnter * silent! lcd %:p:h ]]
