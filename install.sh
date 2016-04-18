#!/bin/bash

reqs=(
    "vim"
    "git"
    "make"
    )

for r in "${reqs[@]}"
do
    command -v $r > /dev/null
    if [ $? -ne 0 ]
    then
        echo "Missing command: ${r}"
        exit 1
    fi
done

has_curl=1
command -v curl > /dev/null
if [ $? -ne 0 ]
then
    has_curl=0
    command -v wget > /dev/null
    if [ $? -ne 0 ]
    then
        echo "Install either curl or wget."
        exit 1
    fi
fi

bundle_dir=$HOME/.vim/bundle/



echo "Installing bundles to: $bundle_dir"

mkdir -p ~/.vim/plugin
cp vimrc ~/.vim/plugin/jimrc.vim

#Install pathogen
mkdir -p ~/.vim/autoload $bundle_dir
if [ $has_curl -eq 1 ]
then
    curl --insecure -LSso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
else
    wget -O ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi
    

if [ $? -ne 0 ]
then
    echo "Error downloading pathogen"
    exit 1
fi

#Install vimproc
if [ ! -d $bundle_dir/vimproc.vim ]; then   
    git clone https://github.com/Shougo/vimproc.vim.git $bundle_dir/vimproc.vim
    cd $bundle_dir/vimproc.vim
    make
    cd -
else
    echo "Directory: vimproc already exists. Skipping..."
fi

#Install Conque
if [ $has_curl -eq 1 ]
then
    curl -LO https://conque.googlecode.com/files/conque_2.3.vmb
else
    wget https://conque.googlecode.com/files/conque_2.3.vmb
fi

if [ $? -ne 0 ]
then
    echo "Error downloading conque"
    exit 1
fi

vim -c 'so %' -c 'q' conque_2.3.vmb

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
        echo "Directory: ${1} already exists. Looking for updates..."
        git --git-dir=$bundle_dir${1}/.git --work-tree=$bundle_dir${1} pull
    fi
}

github_dirs=(
    "nerdtree"
    "ctrlp.vim"
    "vim-airline"
    "vim-easymotion"
    "vim-fugitive"
    "vim-surround"
    "vim-commentary"
    "vim-unimpaired"
    "vim-repeat"
    "rainbow_parentheses.vim"
    "vim-scala"
    "vim-go"
    )
github_repos=(
    "scrooloose/nerdtree.git"
    "kien/ctrlp.vim"
    "bling/vim-airline"
    "Lokaltog/vim-easymotion"
    "tpope/vim-fugitive"
    "tpope/vim-surround"
    "tpope/vim-commentary"
    "tpope/vim-unimpaired"
    "tpope/vim-repeat"
    "kien/rainbow_parentheses.vim"
    "derekwyatt/vim-scala"
    "fatih/vim-go"
    )

for index in ${!github_dirs[*]}
do
    clone ${github_dirs[$index]} ${github_repos[$index]}
done
exit 0
