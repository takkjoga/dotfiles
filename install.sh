#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
  ln -s ~/dotfiles/.vimrc ~/.vimrc
  ln -s ~/dotfiles/.gvimrc ~/.gvimrc
  curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > neobundle_install.sh && sh ./neobundle_install.sh
  ln -s ~/dotfiles/.zshrc ~/.zshrc
  ln -s ~/dotfiles/.gitconfig ~/.gitconfig
  ln -s ~/dotfiles/.gitignore ~/.gitignore
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap d12frosted/emacs-plus
  brew install emacs-plus --with-cocoa --with-gnutls --with-librsvg --with-imagemagick --with-spacemacs-icon
  brew linkapps
  mv ~/.emacs.d ~/.emacs.bak 
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
