# ~/.config/zsh/.zshrc

export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Added by Antigravity CLI installer
export PATH="/home/hope/.local/bin:$PATH"

export COLORTERM="truecolor"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Remove all Windows/mnt paths from the Zsh path array
path=(${path:#/mnt/*})

# Source our custom prompt styling and configuration
source ~/.config/zsh/prompt.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ---------------------------------------------------------
# FISH-LIKE FEATURES via Zinit Turbo Mode
# ---------------------------------------------------------

# Initialize Zsh's completion system (required for the completion strategy to work)
fpath=("$ZDOTDIR/custom_completions" "$ZDOTDIR/functions" $fpath)
autoload -Uz compinit
compinit

# 3. Rich Tab Completions (Interactive Menu)
# Enable the interactive menu selection
zstyle ':completion:*' menu select

# Add descriptions for commands and flags (like Fish)
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# Make the matching smart (case-insensitive and partial match)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Colorize the completion menu to match your ls colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Autosuggestions
# Tell autosuggestions to try history first, and if that fails, try completion (files, commands)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

zinit ice atload'!_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Partial accept ghost completion (one word at a time, like Fish)
# fast-syntax-highlighting clobbers region_highlight on every buffer change (region_highlight=( $reply )),
# which wipes the autosuggestions gray highlight on POSTDISPLAY. This wrapper re-applies it.
_partial_accept_and_rehighlight() {
  zle forward-word
  if (( $#POSTDISPLAY )); then
    region_highlight+=("$#BUFFER $(($#BUFFER + $#POSTDISPLAY)) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")
  fi
}
zle -N _partial_accept_and_rehighlight
bindkey '^[[1;5C' _partial_accept_and_rehighlight
bindkey '^[[1;3C' _partial_accept_and_rehighlight
bindkey '^[[5C'   _partial_accept_and_rehighlight

# 4. History Substring Search (Bind Up/Down arrows to the search)
zinit ice wait lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; \
                             bindkey "$terminfo[kcud1]" history-substring-search-down; \
                             bindkey "^[[A" history-substring-search-up; \
                             bindkey "^[[B" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

# 5. Abbreviations (Expand shortcuts on space)
# We load the zsh-abbr plugin first to enable the 'abbr' command
# (We cannot use 'wait' mode here because we need 'abbr' available immediately for the next line)
export ABBR_USER_ABBREVIATIONS_FILE="$ZDOTDIR/user-abbreviations.DO_NOT_EDIT_HOPE"
zinit ice lucid
zinit light olets/zsh-abbr

# Now we source your external file where you define all your shortcuts.
# (This keeps your .zshrc perfectly clean and organized!)
source ~/.config/zsh/abbreviations.zsh

# Sync abbreviations into Zsh aliases so fast-syntax-highlighting recognizes them as valid commands
for k v in "${(@kv)ABBR_REGULAR_USER_ABBREVIATIONS}"; do
  k="${k#\"}"; k="${k%\"}"
  v="${v#\"}"; v="${v%\"}"
  aliases[$k]="$v"
done

# 6. Smart Directory Navigation
# Implicit cd: Type a directory name to cd into it without typing 'cd'
setopt autocd

# Directory history: Makes Zsh remember the folders you've visited (use 'cd -' then Tab)
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus

# Zoxide: Smarter cd command (initialized to 'cd' command to avoid 'zi' conflicts)
eval "$(zoxide init zsh --cmd cd)"

# 7. FZF (Fuzzy Finder) Keybindings & Completions
# Loads CTRL+T (file finder), CTRL+R (history search), and ALT+C (directory jumper)
eval "$(fzf --zsh)"

# 8. Custom Functions & ZLE Keybindings
autoload -Uz add-zsh-hook
autoload -Uz $ZDOTDIR/functions/[^_]*(:t)

zle -N fzf_file_picker
zle -N yazi_picker
bindkey '^P' fzf_file_picker
bindkey '^O' yazi_picker

add-zsh-hook precmd reset_cursor_to_beam

# Syntax Highlighting
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Dotfiles bare repository alias
alias cfg='/usr/bin/git --git-dir=$HOME/.config/.git/ --work-tree=$HOME'
