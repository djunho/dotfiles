#!/bin/bash

cp tmux.conf $HOME/.tmux.conf

if [ -z "$1" ];  then
    echo -e "Copying the tmux file."
else
    echo -e "This script copies the tmux to the correct place and installs all dependencies if necessary."
    echo -e "\nUsage: $0"
fi
