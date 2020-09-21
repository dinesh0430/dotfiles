# Bash aliases

#alias cd='z '
#alias ch7='chmod 777 '
alias l='exa -F'
alias la='exa -F --icons --group-directories-first -la'
alias ll='exa -F --icons --group-directories-first -l'
alias ls='exa -F --icons --group-directories-first'
alias lt='exa -F --icons --group-directories-first -la --tree -L=3'
alias nvc='$EDITOR /home/hope/.config/nvim/init.vim'
alias gd='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'


# Bash functions

# Copy executable files to sbin
cpsbin() { sudo cp $1 /usr/local/sbin; }

# Create and move to given folder name
mkcd() { mkdir $1; cd $1; }

# Install packages with fzf and yay
yi() {
    SELECTED_PKGS="$(yay -Slq | fzf --header='Install packages' -m --preview 'yay -Si {1}')"
    if [ -n "$SELECTED_PKGS" ]; then
        yay -S $(echo $SELECTED_PKGS)
    fi
}

# Remove packages with fzf and yay
yr() {
    SELECTED_PKGS="$(yay -Qsq | fzf --header='Remove packages' -m --preview 'yay -Si {1}')"
    if [ -n "$SELECTED_PKGS" ]; then
        yay -Rns $(echo $SELECTED_PKGS)
    fi
}
