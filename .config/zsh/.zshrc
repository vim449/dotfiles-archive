export ADOTDIR="$XDG_CACHE_HOME/antigen"
export ANTIGEN_LOG="$XDG_CACHE_HOME/antigen/antigen.log"
source ~/.config/zsh/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
    git
    extract
    python
    pip
    command-not-found
    autojump
    archlinux
    colorize
    github
    hlissner/zsh-autopair
    arzzen/calc.plugin.zsh
    IngoMeyer441/zsh-easy-motion
    hcgraf/zsh-sudo
    softmoth/zsh-vim-mode
    zsh-vi-more/vi-increment
    zsh-vi-more/vi-motions
    zsh-vi-more/vi-quote
    MichaelAquilina/zsh-you-should-use
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
EOBUNDLES
antigen apply

# My attempt at XDG compliance
export PATH=/usr/local/bin:/sbin:/usr/sbin:$HOME/.config/emacs/bin/:$HOME/.local/bin:$HOME/.cabal/bin:$PATH

# Default apps
export EDITOR="nvim"
export VISUAL="nvim"
export READER="zathura"
export TERMINAL="alacritty"
export BROWSER="firefox"
export VIDEO="vlc"
export IMAGE="sxiv"
export OPENER="xdg-open"
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist noma' -\""
export PAGER="less"
export WM="xmonad"

# Setting fd as the default source for fzf
# Now fzf (w/o pipe) will use fd instead of find
export FZF_DEFAULT_COMMAND="fd --type f --ignore-file .gitignore --hidden"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# NNN config
export NNN_TRASH=1
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias cls="clear"
alias vim="nvim"
alias vimrc="nvim $HOME/.config/nvim/init.vim"
alias zshrc="nvim $HOME/.config/zsh/.zshrc"
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias ls="exa --sort .name --icons"
alias l="ls -lah"
alias doom-restart="killall emacs; doom sync; emacs --daemon"
alias vifm="sh $HOME/.config/vifm/scripts/vifmrun"

# Keybindings
bindkey "^ " autosuggest-accept
bindkey -M vicmd ' ' vi-easy-motion
# Vim keys in tab complete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Additional files to source
source /usr/share/nnn/quitcd/quitcd.bash_zsh
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  vim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}
eval "$(starship init zsh)"
