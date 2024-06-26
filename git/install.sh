#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$SCRIPTPATH"

if ! [ -x "$(command -v git)" ]; then
    echo "Installing git"
    sudo apt install git
fi

if ! [ -x "$(command -v delta)" ]; then
    cd /tmp
    curl -s https://api.github.com/repos/dandavison/delta/releases/latest \
          | grep "git-delta_.*_amd64.deb" \
          | cut -d : -f 2,3 \
          | tr -d \" \
          | wget -qi -
    sudo dpkg -i git-delta_*
    cd -
fi

echo "Configuring git"
# Editor
git config --global core.editor "nvim"

# Alias
git config --global alias.co   "checkout"
git config --global alias.sw   "switch"
git config --global alias.br   "branch"
git config --global alias.ci   "commit -v"
git config --global alias.ca   "commit --amend -v"
git config --global alias.df   "diff"
git config --global alias.dc   "diff --cached"
git config --global alias.st   "status"
git config --global alias.cp   "cherry-pick"
git config --global alias.ign  "ls-files -o -i --exclude-standard"
git config --global alias.lg   "log --graph --pretty=format:'%Cred%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all --decorate"
git config --global alias.lgst "log --graph --pretty=format:'%Cred%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all --decorate --stat"
git config --global alias.lgbr "log --graph --pretty=format:'%Cred%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --decorate"
git config --global alias.b    "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"
git config --global alias.sup  "submodule update --init --recursive"
git config --global alias.find-merge "!sh -c 'commit=\$0 && branch=\${1:-HEAD} && (git rev-list \$commit..\$branch --ancestry-path | cat -n; git rev-list \$commit..\$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'"
git config --global alias.show-merge "!sh -c 'merge=\$(git find-merge \$0 \$1) && [ -n \"\$merge\" ] && git show \$merge'"

# Configures the delta
git config --global core.pager                          delta
git config --global delta.light                         false   # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)
git config --global delta.line-numbers                  true
git config --global delta.minus-style                   'syntax "#37222c"'
git config --global delta.minus-non-emph-style          'syntax "#37222c"'
git config --global delta.minus-emph-style              'syntax "#713137"'
git config --global delta.minus-empty-line-marker-style 'syntax "#37222c"'
git config --global delta.line-numbers-minus-style      '"#c25d64"'
git config --global delta.plus-style                    'syntax "#20303b"'
git config --global delta.plus-non-emph-style           'syntax "#20303b"'
git config --global delta.plus-emph-style               'syntax "#2c5a66"'
git config --global delta.plus-empty-line-marker-style  'syntax "#20303b"'
git config --global delta.line-numbers-plus-style       '"#399a96"'
git config --global delta.line-numbers-zero-style       '"#3b4261"'

git config --global interactive.diffFilter              delta --color-only
git config --global delta.navigate                      true    # use n and N to move between diff sections
git config --global merge.conflictstyle                 diff3
git config --global diff.colorMoved                     default
