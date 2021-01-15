syntax on
set encoding=utf-8
set noerrorbells
set relativenumber number
set nowrap
set smartcase
set incsearch
set ignorecase
filetype plugin indent on

set noswapfile
set nobackup
set undodir=$HOME/.config/nvim/undodir
set undofile

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set autoindent smartindent
set fileformat=unix
set foldmethod=indent
set foldlevel=99

set colorcolumn=80
set noshowmode

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
cmap w!! w !sudo tee %

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
