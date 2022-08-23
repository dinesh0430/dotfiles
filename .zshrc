export MANPAGER='nvim +Man!'
export PATH="$HOME/.local/bin:$PATH"

# override default ls colors useful in ls and ls completion
eval "$(dircolors -b $ZDOTDIR/dircolors)"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

FZF_COLORS="bg+:-1,\
fg:#9e9e9e,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:cyan,\
marker:red,\
prompt:magenta,\
hl+:red"

export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--color='$FZF_COLORS' \
--prompt '∷ ' \
--pointer ▶ﰉ \
--marker ⇒"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"

HISTFILE=~/.config/zsh/zsh-history
HISTSIZE=10000
SAVEHIST=10000

source ~/.config/zsh/z/z.sh
export _Z_DATA=/home/hope/.config/zsh/.z_dir_change_cache

#source ~/.config/zsh/bd.zsh

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt auto_list
setopt extendedglob
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
unsetopt beep

bindkey -v              # Enables Vi mode for Vim editing features
export KEYTIMEOUT=1     # Makes the switch between modes faster

PROMPT="
%F{#FFD700}%f %B%F{green}hopeFalconer%f%b %B%F{magenta}@%f%b %U%f%F{blue}%5~%f%u
%(?.%F{blue}ﰉ.%F{red}ﰉ)%f "

# Prompt backup and other symbols
#%B%F{#FFD700} %b%f%F{blue}%5~%f
#%(?.%F{magenta}%F{green}.%F{green})%f "

# Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
autoload -Uz add-zsh-hook vcs_info
# Enable substitution in the prompt.
setopt prompt_subst
# Run vcs_info just before a prompt is displayed (precmd)
add-zsh-hook precmd vcs_info

RPROMPT='%B${vcs_info_msg_0_}%b'

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' -<<'
zstyle ':vcs_info:*' stagedstr ' <<-'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '%F{#FF5F1F}%f %F{green} %f%F{cyan}%b%f%F{magenta}%u%c%f %F{#FF5F1F}%f'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -U compinit; compinit
_comp_options+=(globdots) # Includes hidden files and folders in the completion system

setopt MENU_COMPLETE        # Automatically highlight first element of completion menu, this overrides AUTO_MENUO
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
#zstyle ':completion:*' menu select=2                        # menu if nb items > 2
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
#zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use


# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.config/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification #sorts the completion files based on modification date

zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Colors for files and directory in completion
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

fpop() {
    # Only work with alias d defined as:

    # alias d='dirs -v'
    # for index ({1..9}) alias "$index"="cd +${index}"; unset index

    d | fzf --height="20%" | cut -f 1 | source /dev/stdin
}

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ZSH syntax highlighting from https://github.com/zdharma-continuum/fast-syntax-highlighting

# easily jump to parent directories with few letters or a single letter, see:: https://github.com/vigneshwaranr/bd
alias b=". bd -si"
alias l='exa -F'
alias la='exa -F --group-directories-first -la'
alias ll='exa -F --group-directories-first -l'
alias ls='exa -F --group-directories-first'
alias lt='exa -F --group-directories-first -la --tree -L=3'
alias pacman='sudo pacman'
alias nan="nvim -c 'set ft=man' -"      #use nvim as a manpager
alias cp='cp -iv'
alias mv='mv -iv'
alias rmi='rm -i'
alias nvz='nvim /home/hope/.config/zsh/.zshrc'
alias nvn='nvim /home/hope/.config/nvim/init.vim'
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gds='git diff --staged'
alias gc='git commit -v'

zle_highlight+=(paste:none)             # makes sure that the pasted text is not being highlighted, it is annoying to look at

# Add Vi text-objects for brackets and quotes
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done


# Emulation of vim-surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Increment a number
autoload -Uz incarg
zle -N incarg
bindkey -M vicmd '^a' incarg

#source ~/.config/zsh/
#autoload -Uz _fzf_complete_nvim

source /home/hope/.config/broot/launcher/bash/br

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh   # this should be the last statment

