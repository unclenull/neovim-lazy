set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guifont=FiraCode\ Nerd\ Font\ Mono:h11

command! -nargs=* Cc CopilotChat <args>
nnoremap <Leader>cc :CopilotChat<CR>

call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }
call plug#end()

execute 'luafile ' .  expand('<sfile>:p:h') . '/copilot-chat.lua'
