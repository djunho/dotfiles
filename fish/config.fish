if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g -x fish_greeting ''

    source ~/.local/share/nvim/lazy/tokyonight.nvim/extras/fish/tokyonight_night.fish

    # Check if we are inside Omarchy
    if [ ! -z "$(command -s omarchy-version)" ]
        # File system
        alias ls='eza -lh --group-directories-first --icons=auto'
        alias lsa='ls -a'
        alias lt='eza --tree --level=2 --long --icons --git'
        alias lta='lt -a'
        alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

        function cd
            if test (count $argv) -eq 0
                builtin cd ~
                return
            else if test -d "$argv[1]"
                builtin cd $argv
            else
                z $argv && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
            end
        end

        function open
            xdg-open $argv >/dev/null 2>&1 &
        end

        # Directories
        alias ..='cd ..'
        alias ...='cd ../..'
        alias ....='cd ../../..'

        function n
            if test (count $argv) -eq 0
                nvim .
            else
                nvim $argv
            end
        end

        # Initialize zoxide for the cd function to work properly
        zoxide init fish | source

        # Initialize starship to get the Omarchy default prompt
        starship init fish | source
    end
end
