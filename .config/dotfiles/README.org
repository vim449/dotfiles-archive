#+TITLE: README
#+DESCRIPTION: Configuration files for all apps I use
#+AUTHOR: Dominic Adamson

* Supported Apps
The programs that currently have a proper configuration file are:
+ NeoViM
+ Alacritty
+ AwesomeWM
+ Blender
+ Dmenu
+ Spacemacs
+ Doom Emacs
+ Tmux
+ Zsh
+ Picom
+ OfflineIMAP
+ Mbsync (Inside Emacs configuration)
* Many thanks to DistroTube for his sample configurations that these heavily borrow from

* Install
** To install the following dependencies are needed:
+ =git= for install and updates for all
+ =fd= required by vim, spacemacs(I think), and doom emacs
+ =ripgrep= required by all editors
+ =rtags= for coc(vim extension) and doom emacs
+ =mu= for email and mu4e in all emacs
+ =hub= for github integration for all editors
+ =spellcheck python-black python-pyflakes python-pytest= (optional) for emacs integration
+ Nerd fonts including: Hack, Dejavu, and Meslo
+ App that config is for: =dmenu, nvim, alacritty, emacs, blender, tmux, zsh, picom, offlineIMAP/mbsync, awesome=

These should all be inside of standard repositories or AUR

** Clone this repo into a folder under ~/.config/dotfiles
** Please install oh-my-zsh and powerlevel10k for zsh:
1. Run =sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"= to install oh-my-zsh
2. Run =git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k= to install powerlevel10k
3. Run =git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions= to install zsh-autosuggestions
4. Run =git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting= to install proper syntax highlighting
5. Run =p10k configure= to create the default config for p10k
6. Run =chsh /usr/bin/zsh= to set default shell
7. Update oh-my-zsh
