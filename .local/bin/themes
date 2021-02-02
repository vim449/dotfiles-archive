#!/usr/bin/env sh
theme=$(grep '\s*[0-9a-z_\-]*: &[0=9a-z_\-]*' ~/.config/alacritty/themes.yml | sed 's|: &.*$||' | fzf | sed 's|\s*||g')
sed -i "s|colors: .*|colors: *$theme|;" ~/.config/alacritty/themes.yml
