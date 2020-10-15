#!/usr/bin/env bash
# Dmenu script for editing some of my more frequently edited config files.

declare options=("alacritty
awesome
doom.d/config.el
doom.d/init.el
spacemacs
neovim
picom
zsh
dmenu
tmux
quit")

choice=$(echo -e "${options[@]}" | dmenu -i -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	awesome)
		choice="$HOME/.config/awesome/rc.lua"
	;;
    doom.d/config.el)
		choice="$HOME/.doom.d/config.el"
	;;
    doom.d/init.el)
		choice="$HOME/.doom.d/init.el"
	;;
	neovim)
		choice="$HOME/.config/nvim/init.vim"
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
	zsh)
		choice="$HOME/.config/zsh/.zshrc"
	;;
    tmux)
        choice="$HOME/.config/tmux/tmux.conf"
        ;;
	*)
		exit 1
esac
#alacritty -e nvim "$choice"
emacsclient -c -a emacs "$choice"
