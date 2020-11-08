#!/usr/bin/env bash
#Script to generate random manpages or search for specific one

declare options=("Random
Search
Quit")

choice=$(echo -e "${options[@]}" | dmenu -p 'Manpages: ')

case "$choice" in
    Quit)
        "echo 'Program Terminated." && exit 1
        ;;
    Random)
        find /usr/share/man/man1 -type f | shuf | awk -F '/' '/1/ {print $6}' | sed 's/.gz//g' | head -1 | dmenu -p "Random Manpage:" | xargs alacritty -e man
        ;;
    Search)
        man -k . | awk '{ print $1 }' | sort | dmenu -c -l 20 -g 4 | xargs PAGER=nvim alacritty -e man
        ;;
esac
