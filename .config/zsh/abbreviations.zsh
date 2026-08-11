# ==============================================================================
# FISH-STYLE ABBREVIATIONS
# ==============================================================================
# This file stores abbreviations that expand into their full commands when you
# press the Spacebar. This allows your history to record the actual command you
# ran, making it easier to search through later (and portable across machines).

# Basic utilities
abbr -f -q l="eza --grid --icons=always"
abbr -f -q ls="eza --grid --icons=always"
abbr -f -q la="eza --grid -a --icons=always"
abbr -f -q ll="eza -l --no-user --icons=always"
abbr -f -q llg="eza -l --no-user --git --icons=always"
abbr -f -q ltg="eza -lTh --icons=always --level 3 --group-directories-first --git --no-permissions --no-user --time-style '+%b-%d,%Y %H:%M'"
abbr -f -q ltga="eza -lTah --icons=always --level 3 --group-directories-first --git --no-permissions --no-user --time-style '+%b-%d,%Y %H:%M'"
abbr -f -q lta="eza -lTah --icons=always --level 3 --group-directories-first --no-permissions --no-user --time-style '+%b-%d,%Y %H:%M'"
abbr -f -q v="nvim"
abbr -f -q vz="cd ~/.config/zsh && nvim"
abbr -f -q vv="cd ~/.config/nvim && nvim"
abbr -f -q vs="cd ~/full_vial_qmk_hope/keyboards/sofle/rev1/keymaps/hp_km && nvim"

# Git shortcuts
abbr -f -q g="git"
abbr -f -q gst="git status"
abbr -f -q cfg="/usr/bin/git --git-dir=$HOME/.config/cfg.git/ --work-tree=$HOME"



# Zsh helpers & reload
abbr -f -q rz="exec zsh"
abbr -f -q z="cd"

# Sofle Flashing Abbreviations
abbr -f -q fr="flash_sofle hp_km right"
abbr -f -q fl="flash_sofle hp_km left"

