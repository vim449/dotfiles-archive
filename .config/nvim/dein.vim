" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  "Dein Stuff
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  "Causes highlight to go away on cursor movement
  call dein#add('junegunn/vim-slash')
  "Adds other part of bracket pairs in insert mode
  call dein#add('jiangmiao/auto-pairs', {'on_event': 'InsertEnter'})
  "Finds root of project and makes that cwd
  call dein#add('airblade/vim-rooter')
  "Highlights first letter of each word that could be reached with F
  call dein#add('unblevable/quick-scope')
  "Simple start screen
  call dein#add('mhinz/vim-startify')
  "Adds alignment operators
  call dein#add('tommcdo/vim-lion')

  "Adds nice status line to vim
  "call dein#add('vim-airline/vim-airline')
  "Better status line that I am testing
  call dein#add('glepnir/galaxyline.nvim')
  "Only tolerable theme
  call dein#add('gruvbox-community/gruvbox')
  "Distraction free minor mode
  call dein#add('junegunn/goyo.vim',{'on_cmd': 'Goyo'})
  "Puts CVS status in gutter
  call dein#add('mhinz/vim-signify')
  "Adds undo tree visualizer to vim
  call dein#add('mbbill/undotree', {'on_cmd': 'UndotreeToggle' })
  "Fuzzy finder
  call dein#add('junegunn/fzf', { 'build': './install', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', {'on_cmd': "Files"})
  call dein#add('stsewd/fzf-checkout.vim', { 'on_cmd': 'GCheckout' })
  "LSP for vim
  call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'master', 'build': 'yarn install --frozen-lockfile', 'on_event': 'InsertEnter' })
  "Snippets
  call dein#add('honza/vim-snippets', {'on_event': 'InsertEnter'})
  call dein#add('mattn/emmet-vim', {'on_event': 'InsertEnter'})
  "Interactive REPL scratchpad
  call dein#add('metakirby5/codi.vim', { 'on_cmd': 'Codi' })
  "Grammar checker
  call dein#add('rhysd/vim-grammarous')
  "Uses prompts instead of number for motions
  call dein#add('easymotion/vim-easymotion')

  "Git wrapper similar to Magit
  call dein#add('tpope/vim-fugitive')
  "UNIX helper
  call dein#add('tpope/vim-eunuch')
  "Surrounding pair helper
  call dein#add('tpope/vim-surround', {'on_map': ['ys', 'cs', 'ds'], 'depends': ['vim-repeat']})
  "Making . great again
  call dein#add('tpope/vim-repeat', {'on_map': '.'})
  "Better comment plugin
  call dein#add('tpope/vim-commentary', {'on_map': 'gcc', 'depends': ['vim-repeat']})

  call dein#add('glacambre/firenvim', { 'hook_post_update': { _ -> firenvim#install(0) } })

  "Adds icons
  call dein#add('ryanoasis/vim-devicons')
  call dein#end()
  call dein#save_state()
endif
