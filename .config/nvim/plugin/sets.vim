syntax on
filetype plugin indent on

set noerrorbells
set relativenumber number
set nowrap
set smartcase
set incsearch
set ignorecase

set noswapfile
set nobackup
set undodir=$HOME/.config/nvim/undodir
set undofile
set hidden

set scrolloff=8
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set autoindent smartindent
set fileformat=unix

set colorcolumn=80
set noshowmode
set cursorcolumn
set cursorline
set signcolumn=yes
set termguicolors

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function Inc(...)
  let result = g:i
  let g:i += a:0 > 0 ? a:1 : 1
  return result
endfunction

autocmd BufWritePre * :call TrimWhitespace()
