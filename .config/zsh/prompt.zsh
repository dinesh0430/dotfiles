# ==============================================================================
# 0. COLORS (16-COLOR ANSI PALETTE MAP)
# ==============================================================================
# Standard Colors (0-7)
export C_BLACK="%F{0}"
export C_RED="%F{1}"
export C_GREEN="%F{2}"
export C_YELLOW="%F{3}"
export C_BLUE="%F{4}"
export C_MAGENTA="%F{5}"
export C_CYAN="%F{6}"
export C_WHITE="%F{7}"

# Bright/High-Intensity Colors (8-15)
export C_BRIGHT_BLACK="%F{8}"    # often used as dim/gray
export C_BRIGHT_RED="%F{9}"
export C_BRIGHT_GREEN="%F{10}"
export C_BRIGHT_YELLOW="%F{11}"
export C_BRIGHT_BLUE="%F{12}"
export C_BRIGHT_MAGENTA="%F{13}"
export C_BRIGHT_CYAN="%F{14}"
export C_BRIGHT_WHITE="%F{15}"

export C_RESET="%f"

# ==============================================================================
# 1. CUSTOM PATH FUNCTION (Bright Git root/current dir, dim intermediate)
# ==============================================================================
# This function dynamically formats your current directory path based on whether
# you are inside a Git repository or not. It breaks down the path folder-by-folder
# and applies different colors (bold cyan for root/current, dim green for others).
custom_fancy_path() {
  local p="${PWD/#$HOME/~}"
  local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  
  # Map to our global descriptive variables
  local bright="%B$C_BRIGHT_CYAN"
  local dim="%{\e[3m%}$C_GREEN"
  local reset="%b%{\e[23m%}$C_RESET"
  
  if [[ -z "$git_root" ]]; then

    local parent_path="${p%/*}"
    local current_dir="${p##*/}"
    if [[ "$parent_path" == "$current_dir" ]]; then
      echo "${bright}${current_dir}${reset}"
    else
      echo "${dim}${parent_path}/${reset}${bright}${current_dir}${reset}"
    fi
    return
  fi

  local repo_name=$(basename "$git_root")
  local current_dir=$(basename "$PWD")
  local formatted_path=""
  
  # Native Zsh array splitting by '/'
  local path_array=(${(s:/:)p})
  
  for dir in "${path_array[@]}"; do

    if [[ -z "$dir" ]]; then continue; fi
    if [[ "$dir" == "$repo_name" || "$dir" == "$current_dir" ]]; then
      formatted_path+="${bright}${dir}${reset}/"
    else
      formatted_path+="${dim}${dir}${reset}/"
    fi

  done
  
  echo "${formatted_path%/}"
}

# ==============================================================================
# 2. PURE PROMPT INITIALIZATION & CONFIG
# ==============================================================================

# Load Pure from our new config folder
fpath+=($HOME/.config/zsh/pure)
autoload -U promptinit; promptinit
prompt pure

# Symbols
PURE_PROMPT_SYMBOL=''
PURE_GIT_BRANCH_SYMBOL=' '
PURE_GIT_UP_ARROW='↑'
PURE_GIT_DOWN_ARROW='↓'

# Colors
# We use '10' instead of 'green' because 10 maps to the bright-green ANSI color code.
zstyle :prompt:pure:prompt:success color magenta
zstyle :prompt:pure:prompt:error color red
zstyle :prompt:pure:git:branch color 10

zstyle :prompt:pure:git:arrow color 10
zstyle :prompt:pure:git:dirty color 10

# setopt prompt_subst: Tells Zsh to live-evaluate the prompt string every time it 
# draws a new line. This is what allows $(custom_fancy_path) to execute dynamically
# when you change directories, instead of being evaluated only once at startup.
setopt prompt_subst

# ------------------------------------------------------------------------------
# THE CUSTOM HOOK: prompt_pure_precustom
# ------------------------------------------------------------------------------
# Pure runs this hook right before rendering. We use it to overwrite Pure's native
# 'prompt_pure_path_segment' with our own custom string containing our prefix,
# username, and the output of $(custom_fancy_path). Pure then natively attaches
# its Git status segment immediately after this string.
prompt_pure_precustom() {
    prompt_pure_path_segment="${C_BRIGHT_GREEN} ${C_RESET}${C_BRIGHT_YELLOW}${USER}${C_RESET}${C_WHITE} @ ${C_RESET}$(custom_fancy_path)"
}

# ------------------------------------------------------------------------------
# RIGHT PROMPT: COMMAND EXECUTION TIME
# ------------------------------------------------------------------------------
# We configure Pure to always track execution time (even if it's 0s).
export PURE_CMD_MAX_EXEC_TIME=0

# Pure normally puts the execution time on the left. We strip it out of PROMPT:
PROMPT=${PROMPT//'%(19V. %F{$prompt_pure_colors[execution_time]}%19v%f.)'/}

# And place it into the right-hand prompt (RPROMPT) instead:
RPROMPT='%(19V.%F{$prompt_pure_colors[execution_time]}%19v%f.)'
