#!/bin/bash

# Not my original work, this script comes from:
# https://github.com/TomNomNom/dotfiles/
#
# Thanks to Tom Hudson for this

echo "Setting up this user with standard dotfiles"

dotfilesDir=$(pwd)

function linkDotFile {
    src="${1}"
    dest="${HOME}/${src/dot./.}"
    performLink "${src}" "${dest}"
}

function performLink {
    src="${1}"
    dest="${2}"
    dateStr=$(date +%Y-%m-%d-%H%M)
    if [ -h "${dest}" ]; then
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
    ln -s ${dotfilesDir}/${src} ${dest}
}

function ensureDir {
    if [ -d "$1" ]; then
        return
    fi
    mkdir -p "$1"
    chmod $2 "$1"
}

for x in dot.*; do
    linkDotFile $x
done

ensureDir "${HOME}/.ssh" 700
ensureDir "${HOME}/.phpcs" 755

performLink special.sshconfig "${HOME}/.ssh/config"
performLink phpcs-rules.xml "${HOME}/.phpcs/rules.xml"

git submodule init
git submodule update

vim -T dumb -e -c "set nomore" +PluginInstall +qall > /dev/null
