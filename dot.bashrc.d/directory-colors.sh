
# OSX is different
if [[ $OSTYPE == darwin* ]]; then
    export CLICOLOR=YES
else
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
    fi
fi

