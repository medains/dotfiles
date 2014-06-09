#!/bin/bash

# Not my original work, this script comes from:
# https://github.com/TomNomNom/dotfiles/
#
# Thanks to Tom Hudson for this

echo "Setting up this user with standard dotfiles"

dotfilesDir=$(pwd)

function linkDotfile {
    dest="${HOME}/${1}"
    dateStr=$(date +%Y-%m-%d-%H%M)
    if [ -h ~/${1} ]; then
        echo "Removing existing symlink: ${dest}"
        rm ${dest}
    elif [ -f "${dest}" ]; then
        echo "Backing up existing file: ${dest}"
        mv ${dest}{,.${dateStr}}
    elif [ -d "${dest}" ]; then
        echo "Backing up existing dir: ${dest}"
        mv ${dest}{,.${dateStr}}
    fi
    echo "Creating new symlink: ${dest}"
    ln -s ${dotfilesDir}/${1} ${dest}
}

linkDotfile .vim
linkDotfile .vimrc

git submodule init
git submodule update
