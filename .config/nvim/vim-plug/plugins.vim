"auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

"Small throw away plugins
Plug 'junegunn/vim-slash'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-rooter'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-eunuch'
Plug 'mhinz/vim-startify'

"Themes and aesthetics
Plug 'vim-airline/vim-airline'
Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'airblade/vim-gitgutter'

"Complex plugins to make vim closer to an IDE
"These plugins will likely require additional configuration
Plug 'mbbill/undotree', {'on': 'UndotreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { ->fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim', { 'on': 'GCheckout' }
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'honza/vim-snippets'
Plug 'metakirby5/codi.vim', { 'on': 'Codi' }
Plug 'vimwiki/vimwiki'
Plug 'rhysd/vim-grammarous'

"Requires sourcing after most plugins
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
