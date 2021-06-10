#!/usr/bin/env zsh

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
    archlinux
    colorize
    github
    hlissner/zsh-autopair
    arzzen/calc.plugin.zsh
    IngoMeyer441/zsh-easy-motion
    hcgraf/zsh-sudo
    zsh-vi-more/vi-increment
    zsh-vi-more/vi-motions
    zsh-vi-more/vi-quote
    MichaelAquilina/zsh-you-should-use
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-completions
    softmoth/zsh-vim-mode
EOBUNDLES
antigen apply


# Default apps
export EDITOR="nvim"
export VISUAL="nvim"
export READER="zathura"
export TERMINAL="alacritty"
export BROWSER="firefox"
export VIDEO="vlc"
export IMAGE="sxiv"
export OPENER="xdg-open"
export MANPAGER="nvim -c 'set ft=man' -"
export PAGER="less"
export WM="xmonad"

# Setting fd as the default source for fzf
# Now fzf (w/o pipe) will use fd instead of find
export FZF_DEFAULT_COMMAND="fd --type f --ignore-file .gitignore --hidden"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Aliases
alias cls="clear"
alias vim="nvim"
alias vimrc="$EDITOR $HOME/.config/nvim/init.vim"
alias zshrc="$EDITOR $HOME/.config/zsh/.zshrc"
alias config="/usr/bin/git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME"
alias ls="exa --sort .name --icons -G --git"
alias l="ls -lah"
alias doom-restart="killall emacs; doom sync; emacs --daemon"
alias vifm="sh $HOME/.config/vifm/scripts/vifmrun"
alias cat="bat"
alias du="dust"
alias grep"rg"
alias btm="btm --color gruvbox"
alias top="btm -b"
alias "sudo nvim"="sudo -e"
alias wget="wget --hsts-file='$XDG_CACHE_HOME/wget-hsts'"
alias q="exit"

# Keybindings
bindkey -v
bindkey "^[ " autosuggest-accept
bindkey -M vicmd ' ' vi-easy-motion
# Vim keys in tab complete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
autopair-init

# ZSH config
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
export FZF_COMPLETION_OPTS='--border --info=inline'

eval "$(starship init zsh)"
