
if ! [ -x "$(command -v git)" ]; then
    echo "Installing git"
    sudo apt install git
fi

echo "Configuring git"
# Editor
git config --global core.editor "vim"

# Alias
git config --global alias.co   "checkout"
git config --global alias.br   "branch"
git config --global alias.ci   "commit"
git config --global alias.ca   "commit --amend"
git config --global alias.df   "diff"
git config --global alias.dc   "diff --cached"
git config --global alias.st   "status"
git config --global alias.br   "branch"
git config --global alias.cp   "cherry-pick"
git config --global alias.ign  "ls-files -o -i --exclude-standard"
git config --global alias.lg   "log --graph --pretty=format:'%Cred%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all --decorate"
git config --global alias.lgst "log --graph --pretty=format:'%Cred%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all --decorate --stat"
git config --global alias.lgbr "log --graph --pretty=format:'%Cred%h%Creset -%C(red)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --decorate"
git config --global alias.b    "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"
git config --global alias.sup  "submodule update --init --recursive"
