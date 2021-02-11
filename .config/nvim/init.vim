set exrc " Needs to be here for security reasons

"auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.config/nvim/autoload/plugged')
" Small throw away plugins
Plug 'junegunn/vim-slash' "Causes highlight to go away on cursor movement
Plug 'jiangmiao/auto-pairs' "Adds other part of bracket pairs in insert mode
Plug 'airblade/vim-rooter' "Finds root of project and makes that cwd
Plug 'unblevable/quick-scope' "Makes f faster
Plug 'mhinz/vim-startify' "Simple start screen
Plug 'tommcdo/vim-lion' "Adds alignment operators
Plug 'dbeniamine/cheat.sh-vim' "Cheatsheet
Plug 'rhysd/vim-grammarous' "Grammar checker
Plug 'theprimeagen/vim-be-good' "What it sounds like

" Themes and aesthetics
Plug 'vim-airline/vim-airline' "Adds nice status line to vim
Plug 'gruvbox-community/gruvbox' "Only tolerable theme
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } "Distraction free minor mode
Plug 'mhinz/vim-signify' "Puts CVS status in gutter for each line
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' } "Highlights colors

" Complex plugins to make vim closer to an IDE
" These plugins will likely require additional configuration
Plug 'mbbill/undotree', {'on': 'UndotreeToggle' } "Adds undo tree visualizer to vim
Plug 'junegunn/fzf', { 'do': { ->fzf#install() } } "Fuzzy finder
Plug 'junegunn/fzf.vim' "Second half
Plug 'stsewd/fzf-checkout.vim', { 'on': 'GCheckout' } "Addon to FZF for git
" Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'} "LSP for vim
Plug 'neovim/nvim-lspconfig'
Plug 'honza/vim-snippets' "Snippets
Plug 'mattn/emmet-vim'
Plug 'metakirby5/codi.vim', { 'on': 'Codi' } "Interactive REPL scratchpad
Plug 'easymotion/vim-easymotion' "Uses prompts instead of number for motions
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Treesitter
Plug 'nvim-treesitter/playground' "Treesitter devel playground
Plug 'vifm/vifm.vim' "Only functional file manager

Plug 'voldikss/vim-floaterm' "Basically posframe
Plug 'nvim-lua/popup.nvim' " Random dep for telescope
Plug 'nvim-lua/plenary.nvim' " Random dep for telescope
Plug 'nvim-telescope/telescope.nvim' "Weird ill-defined FZF thing

" Tim Pope plugins. Makes vim closer to being usable
Plug 'tpope/vim-fugitive' "Git wrapper similar to Magit
Plug 'tpope/vim-eunuch' "UNIX helper
Plug 'tpope/vim-surround' "Surrounding pair helper
Plug 'tpope/vim-repeat' "Making . great again
Plug 'tpope/vim-commentary' "Better comment plugin

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } } "Vim inside browser

Plug 'ryanoasis/vim-devicons' "Adds icons
call plug#end()

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
