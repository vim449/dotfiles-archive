local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim'}

    use 'jiangmiao/auto-pairs' -- Adds other part of bracket pairs in insert mode
    use 'airblade/vim-rooter' -- Finds root of project and makes that cwd
    use 'unblevable/quick-scope' -- Makes f faster
    use 'mhinz/vim-startify' -- Simple start screen
    use 'tommcdo/vim-lion' -- Adds alignment operators
    use 'dbeniamine/cheat.sh-vim' -- Cheatsheet
    use 'rhysd/vim-grammarous' -- Grammar checker
    use 'theprimeagen/vim-be-good' -- What it sounds like

    -- Themes and aesthetics
    use 'vim-airline/vim-airline' -- Adds nice status line to vim
    use 'gruvbox-community/gruvbox' -- Only tolerable theme
    use 'junegunn/goyo.vim' -- Distraction free minor mode
    use {'rrethy/vim-hexokinase', run = 'make hexokinase'} -- Highlights colors
    use 'mhinz/vim-signify' -- Puts CVS status in gutter for each line

    -- Complex plugins to make vim closer to an IDE
    -- These plugins will likely require additional configuration
    use {
        -- Adds undo tree visualizer to vim
        'mbbill/undotree',
        -- cmd = 'UndotreeToggle',
        -- ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'vim', 'tex', 'lua',}
    }
    use {
        'neoclide/coc.nvim', branch = 'release',
    } -- LSP for vim
    use {
        'honza/vim-snippets',
        after = 'neoclide/coc.nvim',
        event = "InsertEnter"} -- Snipptes
    use 'mattn/emmet-vim'
    use {'metakirby5/codi.vim', opt = true, cmd = 'Codi'} -- Interactive REPL scratchpad
    use 'easymotion/vim-easymotion' -- Uses prompts instead of number for motions
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-treesitter/playground' -- Treesitter devel playground
    use 'vifm/vifm.vim' -- Only functional file manager
    use 'voldikss/vim-floaterm' -- Basically posframe
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope-fzy-native.nvim'}}
    }

    -- Tim Pope plugins. Makes vim closer to being usable
    use 'tpope/vim-fugitive' -- Git wrapper similar to Magit
    use 'tpope/vim-eunuch' -- UNIX helper
    use 'tpope/vim-surround' -- Surrounding pair helper
    use 'tpope/vim-repeat' -- Making . great again
    use 'tpope/vim-commentary' -- Better comment plugin

    use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end } -- Vim inside browser
    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'

    -- Lazy loading:
    -- Load on specific commands
    use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

end)
