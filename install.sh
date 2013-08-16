#!/bin/bash

bundle_dir=$HOME/.vim/bundle/

echo "Installing bundles to: $bundle_dir"

mkdir -p ~/.vim/plugin
cp vimrc ~/.vim/plugin/jimrc.vim

#Install pathogen
mkdir -p ~/.vim/autoload $bundle_dir
curl -Sso ~/.vim/autoload/pathogen.vim \
	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

if [ $? -ne 0 ]
then
    echo "Error downloading pathogen"
    exit 1
fi

#TODO this might not be necessary since it is in the plugin
touch ~/.vimrc
if ! grep -Fxq "execute pathogen#infect()" ~/.vimrc
then
    echo "execute pathogen#infect()" >> ~/.vimrc
fi

clone() {
    if [ ! -d $bundle_dir${1} ]; then
        git clone http://github.com/${2} $bundle_dir${1}
        if [ $? -ne 0 ]
        then
            echo "Error cloning ${2}!"
            exit 1
        fi
    else
        echo "Directory: ${1} already exists. Skipping..."
    fi
}

github_dirs=("nerdtree" "ctrlp.vim" "vim-airline" "vim-easymotion" "vim-fugitive")
github_repos=("scrooloose/nerdtree.git" "kien/ctrlp.vim" "bling/vim-airline" "Lokaltog/vim-easymotion" "tpope/vim-fugitive")

for index in ${!github_dirs[*]}
do
    clone ${github_dirs[$index]} ${github_repos[$index]}
done
exit 0
