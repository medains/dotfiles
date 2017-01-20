# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -d ~/.bashrc.d ]; then
    for x in ~/.bashrc.d/*; do
       . $x
    done
fi

export EDITOR=vim
export LESSCHARSET=UTF-8

export PATH="/usr/local/sbin:$PATH"

