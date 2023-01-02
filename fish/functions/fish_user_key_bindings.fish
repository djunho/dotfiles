function fish_user_key_bindings
    bind -k f9 "git status; echo -e '\n'; commandline -f repaint"
    bind -k f12 "echo -ne '\ec\e[3J'; commandline -f repaint"
    bind \cc 'commandline ""'
end
