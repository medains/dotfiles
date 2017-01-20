# Use tput to determine terminal colour support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    if [ `tput colors` -eq 256 ]; then
        PS1='\[\e[38;5;84m\]\u@\h\[\e[0m\]:\[\e[38;5;14m\]\W\[\e[00m\]\$ '
    else
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='\u@\h:\w\$ '
fi

