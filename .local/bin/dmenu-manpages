#!/usr/bin/env bash
#Script to generate random manpages or search for specific one

declare options=("Random
Search
Quit")

choice=$(echo -e "${options[@]}" | dmenu -i -p 'Manpages: ')

case "$choice" in
    Quit)
        "echo 'Program Terminated." && exit 1
        ;;
    Random)
        find /usr/share/man/man1 -type f | shuf | awk -F '/' '/1/ {print $6}' | sed 's/.gz//g' | head -1 | dmenu -i -p "Random Manpage:" | xargs alacritty -e man
        ;;
    Search)
        man -k . | awk '{ print $1 }' | sort | dmenu -i -c -l 20 -g 4 | xargs alacritty -e man
        ;;
esac
