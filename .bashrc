#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=nvim

# To give permissions to execute bash files
cd ~/scripts
watchexec --exts bash ./grant-* &

# change to home directory
cd ~

# Node Version Manager (NVM) and nodejs
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bash prompt
eval "$(starship init bash)"
export _ZO_FZF_OPTS='--height=25%'
export _ZO_ECHO=1
eval "$(zoxide init --cmd=j bash)"

source ~/.bash_aliases

source /home/hope/.config/broot/launcher/bash/br
