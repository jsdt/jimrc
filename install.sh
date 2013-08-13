#!/bin/bash

mkdir -p ~/.vim/plugin
cp vimrc ~/.vim/plugin/jimrc.vim

#Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim \
	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

if [ $? -ne 0 ]
then
    echo "Error downloading pathogen"
    exit 1
fi

touch ~/.vimrc
if ! grep -Fxq "execute pathogen#infect()" ~/.vimrc
then
    echo "execute pathogen#infect()" >> ~/.vimrc
fi


cd ~/.vim/bundle
#Download nerdtree
git clone https://github.com/scrooloose/nerdtree.git

if [ $? -ne 0 ]
then
    echo "Error cloning nerdtree"
    exit 1
fi
#Download ctrlp
git clone https://github.com/kien/ctrlp.vim

if [ $? -ne 0 ]
then
    echo "Error cloning ctrlp"
    exit 1
fi
