#!/usr/bin/env bash

# Based on the https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-cht.sh
selected=`cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf`

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if [ ! -z $query ]; then
    if grep -qs "$selected" ~/.tmux-cht-languages; then
        query=`echo $query | tr ' ' '+'`
        tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
    else
        tmux neww bash -c "curl -s cht.sh/$selected~$query | less -R"
    fi
else
    tmux neww bash -c "curl -s cht.sh/$selected | less -R"
fi
