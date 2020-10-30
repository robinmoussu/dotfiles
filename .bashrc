# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
if ! [[ "$PATH" =~ "$HOME/.cargo/bin" ]]
then
    PATH="$HOME/.cargo/bin:$PATH"
fi
export PATH

[[ $- == *i* ]] && { # only if shell is interactive

    # .bashrc
    GREEN="\[\e[0;32m\]"
    RED="\[\e[0;31m\]"
    RESET="\[\e[0m\]"
    export PS1="${GREEN}\h [\w] ${RESET}> "

    # Globbing
    shopt -s globstar
    set show-all-if-ambiguous on

    export LESS=FRX

    HISTSIZE=10000
    HISTFILESIZE=20000

    rg() {
        if [ -t 1 ]; then
            command rg -p "$@" | less
        else
            command rg "$@"
        fi
    }

    # disable ctrl+s
    stty -ixon

    if ! [[ "$PATH" =~ "$HOME/scripts" ]]
    then
        PATH="$PATH:$HOME/scripts"
    fi

    alias ll='ls -lh'
}

if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
