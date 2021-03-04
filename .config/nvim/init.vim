set exrc " Needs to be here for security reasons

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }
let mapleader=" "

if executable('rg')
    let g:rg_derive_root='true'
endif

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <silent> <leader>= :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"Terminal window navigation
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
tnoremap <Esc> <C-\><C-n>

" Fix Y
nnoremap Y y$

" Indent visual block
vnoremap < <gv
vnoremap > >gv

" Toggle spell check
map <leader>s :setlocal spell! spelllang=en_us<CR>

" Save file as sudo when no sudo permissions
cmap w!! w !sudo tee > /dev/null %

" Replace all
nnoremap <leader>pr :%s//gI<Left><Left><Left>

"Themes
source $HOME/.config/nvim/themes/gruvbox.vim
source $HOME/.config/nvim/themes/airline.vim
