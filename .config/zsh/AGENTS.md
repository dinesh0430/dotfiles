# Zsh Configuration Architecture & Agent Rules

This workspace contains a highly customized, modular Zsh configuration. Any AI assistant or developer modifying these files **must** adhere to the structural and load-order constraints documented below, and **must keep this `AGENTS.md` file updated** whenever introducing new architectural patterns, functions, plugins, or configuration rules, as well as any helpful execution tidbits, fixes, or shell quirks discovered along the way.

---

## 1. Strict File Structure & Purpose

- `~/.zshenv`: Sets `export ZDOTDIR="$HOME/.config/zsh"`. This redirects Zsh to load all configuration files from `~/.config/zsh` instead of `~`. Do not delete or bypass this setting.
- `~/.config/zsh/.zshrc`: The main entry point. Keep this file lean; only load system paths, Zinit initialization, Zsh options, and plugin definitions here.
- `~/.config/zsh/prompt.zsh`: Pure prompt initialization, color palette maps (`C_*`), path formatting function (`custom_fancy_path`), and right prompt (`RPROMPT`) execution timer logic.
- `~/.config/zsh/abbreviations.zsh`: All custom shortcuts and expansions using `abbr`.
- `~/.config/zsh/user-abbreviations.DO_NOT_EDIT_HOPE`: Auto-generated storage file managed by the `zsh-abbr` plugin. **Do not edit manually.** It is automatically updated when `abbreviations.zsh` is sourced during shell startup or when `abbr` commands are run interactively (redirected via `export ABBR_USER_ABBREVIATIONS_FILE="$ZDOTDIR/user-abbreviations.DO_NOT_EDIT_HOPE"` in `.zshrc`). All custom user abbreviations must be added to `abbreviations.zsh` instead.
- `~/.config/zsh/fsh/overlay.ini`: Theme overrides for `fast-syntax-highlighting` (`~/.config/fsh` is symlinked to `~/.config/zsh/fsh` for compatibility).

---

## 2. Critical Load Order Rules in `.zshrc`

1. **`compinit`**: `fpath=("$ZDOTDIR/functions" $fpath)` MUST be set BEFORE `compinit` is called near the top of `.zshrc` so that Zsh scans `$ZDOTDIR/functions` for `#compdef` headers.
2. **Synchronous Plugins**: 
   - `olets/zsh-abbr` **MUST NOT** use `zinit ice wait`. It must load synchronously so that `abbr` commands in `abbreviations.zsh` are recognized at startup.
   - `export ABBR_USER_ABBREVIATIONS_FILE="$ZDOTDIR/user-abbreviations.DO_NOT_EDIT_HOPE"` MUST be set before `zinit light olets/zsh-abbr` to keep abbreviation state inside `~/.config/zsh/` instead of `~/.config/zsh-abbr/`.
3. **`fast-syntax-highlighting`**: **MUST ALWAYS BE THE VERY LAST PLUGIN IN `.zshrc`**.
   - Any new Zinit plugin or completion module must be inserted *above* `zdharma-continuum/fast-syntax-highlighting`.

---

## 3. Shortcut & Alias Policy

- **Do NOT add standard Zsh `alias` lines directly into `.zshrc`.**
- All shortcuts must be defined as abbreviations using `abbr <name>="<command>"` inside `~/.config/zsh/abbreviations.zsh`. This ensures spacebar expansion and clean history logging across environments.

---

## 4. Zoxide & Navigation Setup

- Zoxide is initialized with:
  ```zsh
  eval "$(zoxide init zsh --cmd cd)"
  ```
- **Do NOT** change `--cmd cd` back to standard `z`. Using `--cmd cd` assigns Zoxide to `cd` and its interactive search to `cdi`, which avoids breaking `zi` (used by Zinit).
- Native navigation settings (`autocd`, `auto_pushd`, `pushd_ignore_dups`, `pushd_minus`) are enabled in `.zshrc` and should remain active.

---

## 5. Syntax Highlighting Color Adjustments

- Do not edit the default `fast-syntax-highlighting` theme files.
- Custom token colors (such as error tokens or command colors) must be added to `~/.config/zsh/fsh/overlay.ini` (symlinked via `~/.config/fsh/overlay.ini`) and applied with `fast-theme XDG:overlay`.

---

## 6. Custom Functions (`~/.config/zsh/functions/`)

- **File Header & Modelines**: Every function file placed inside `~/.config/zsh/functions/` MUST start with a Zsh shebang and a Neovim modeline:
  ```zsh
  #!/usr/bin/env zsh
  # vim: ft=zsh
  ```
  This ensures Neovim and other editors properly recognize and syntax highlight the file without requiring a `.zsh` file extension.
- **Autoloading & Execution Architecture**: Functions are stored as individual extensionless files matching the function name and dynamically autoloaded via `autoload -Uz $ZDOTDIR/functions/*(:t)`.
  - **Invocation Call Requirement**: If a file wraps its implementation inside `funcname() { ... }`, the bottom of the file MUST include `funcname "$@"` so Zsh executes the function immediately upon first invocation when autoloaded.
  - **Scope Isolation**: Do NOT append global environment settings (e.g. `export PATH=...`) or stray installer configs inside `~/.config/zsh/functions/` files. All global exports belong in `.zshrc`.

---

## 7. Custom Completions & Autosuggestion Strategies

- **Tab Completions**: Place custom completion functions in `$fpath` using standard Zsh completion headers (`#compdef <command>`).
- **Dynamic Autosuggestion Strategy**: When specific commands require completion-first autosuggestions while the global default is `(history completion)`, use a custom strategy wrapper function (e.g., `_zsh_autosuggest_strategy_dynamic`) registered in `ZSH_AUTOSUGGEST_STRATEGY=(dynamic)`.
- **Partial Acceptance of Ghost Suggestions**: `Ctrl+Right` and `Alt+Right` are bound to a custom `_partial_accept_and_rehighlight` ZLE widget (not raw `forward-word`) to accept one word of the ghost suggestion at a time (matching Fish shell behavior). A raw `forward-word` binding will NOT work because `fast-syntax-highlighting` clobbers `region_highlight` on every buffer change (`region_highlight=( $reply )`), wiping the autosuggestions gray highlight on `POSTDISPLAY`. The wrapper calls `forward-word` and then re-inserts the gray highlight entry.
- **Ghost Text Styling**: `export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"` explicitly sets unaccepted ghost completion text to dim gray so accepted words get colored by `fast-syntax-highlighting` while remaining words stay gray.

---

## 8. ZLE Widgets & Precmd Hooks

- Functions meant for keybindings must be registered with `zle -N <widget_name>` in `.zshrc`.
- Functions hookable into the prompt lifecycle must use `add-zsh-hook precmd <func_name>`.

---

## 9. Path & WSL Interop Cleanliness

- Maintain WSL path filtering in `.zshrc` (`path=(${path:#/mnt/*})`) to avoid severe performance degradation caused by Windows drive mount resolution on Linux/WSL.
