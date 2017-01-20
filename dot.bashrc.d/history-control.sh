
# don't put duplicate lines in the history.
export HISTCONTROL=ignoredups
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000
# ignore some things in history file
export HISTIGNORE="%:ls:exit:history"

# append to the history file, don't overwrite it
shopt -s histappend

