"auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

"Small throw away plugins
"Plug 'junegunn/vim-slash' "Causes highlight to go away on cursor movement
"Plug 'jiangmiao/auto-pairs' "Adds other part of bracket pairs in insert mode
"Plug 'airblade/vim-rooter' "Finds root of project and makes that cwd
"Plug 'unblevable/quick-scope' "Highlights first letter of each word that could be reached with F
"Plug 'mhinz/vim-startify' "Simple start screen
"Plug 'tommcdo/vim-lion' "Adds alignment operators

"Themes and aesthetics
" Plug 'vim-airline/vim-airline' "Adds nice status line to vim
"Plug 'glepnir/galaxyline.nvim' "Better status line that I am testing
"Plug 'gruvbox-community/gruvbox' "Only tolerable theme
"Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } "Distraction free minor mode
"Plug 'mhinz/vim-signify' "Puts CVS status in gutter for each line

"Complex plugins to make vim closer to an IDE
"These plugins will likely require additional configuration
"Plug 'mbbill/undotree', {'on': 'UndotreeToggle' } "Adds undo tree visualizer to vim
"Plug 'junegunn/fzf', { 'do': { ->fzf#install() } } "Fuzzy finder
"Plug 'junegunn/fzf.vim' "Second half
"Plug 'stsewd/fzf-checkout.vim', { 'on': 'GCheckout' } "Addon to FZF for git
"Plug 'neoclide/coc.nvim', { 'branch': 'release' } "LSP for vim
"Plug 'honza/vim-snippets' "Snippets
"Plug 'metakirby5/codi.vim', { 'on': 'Codi' } "Interactive REPL scratchpad
"Plug 'rhysd/vim-grammarous' "Grammar checker
"Plug 'easymotion/vim-easymotion' "Uses prompts instead of number for motions
"Plug 'mattn/emmet-vim'

" Tim Pope plugins. Makes vim closer to being usable
"Plug 'tpope/vim-fugitive' "Git wrapper similar to Magit
"Plug 'tpope/vim-eunuch' "UNIX helper
"Plug 'tpope/vim-surround' "Surrounding pair helper
"Plug 'tpope/vim-repeat' "Making . great again
"Plug 'tpope/vim-commentary' "Better comment plugin

" Vim inside browser
"Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

"Requires sourcing after most plugins
"Plug 'ryanoasis/vim-devicons' "Adds icons

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
