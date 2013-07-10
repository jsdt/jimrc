#!/bin/bash

mkdir -p ~/.vim/plugin
cp vimrc ~/.vim/plugin/jimrc.vim

#Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim \
	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

touch ~/.vimrc
if ! grep -Fxq "execute pathogen#infect()" ~/.vimrc
then
    echo "execute pathogen#infect()" >> ~/.vimrc
fi


cd ~/.vim/bundle
#Download nerdtree
git clone https://github.com/scrooloose/nerdtree.git
#Download ctrlp
git clone https://github.com/kien/ctrlp.vim

