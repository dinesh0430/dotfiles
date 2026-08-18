# Neovim Configuration Guide & Agent Context (`AGENTS.md`)

This document provides context, keyboard shortcuts, terminal quirks, and troubleshooting fixes for AI agents working on this Neovim configuration.

---

## 1. Terminal Quirks (Alacritty on Windows + WSL)

When running Neovim inside WSL using Alacritty on Windows, several key combinations (`Ctrl+Tab`, `Ctrl+Shift+Tab`, `Ctrl+Space`) do not send standard terminal escape sequences by default.

To fix these in Alacritty, the Windows `alacritty.toml` config (`%APPDATA%\alacritty\alacritty.toml`) must contain the following keyboard bindings:

```toml
# Enable Ctrl+Tab and Ctrl+Shift+Tab
[[keyboard.bindings]]
key = "Tab"
mods = "Control"
chars = "\u001b[27;5;9~"

[[keyboard.bindings]]
key = "Tab"
mods = "Control|Shift"
chars = "\u001b[27;6;9~"

# Enable Ctrl+Space for nvim-cmp completion
[[keyboard.bindings]]
key = "Space"
mods = "Control"
chars = "\u0000"
```

---

## 2. Keybindings Reference (`lua/config/keybinds.lua`)

| Mode | Keybinding | Command / Action | Description |
| :--- | :--- | :--- | :--- |
| **Normal** | `<leader>cd` | `<cmd>NvimTreeToggle<cr>` | Toggle NvimTree file explorer |
| **Normal** | `<C-Tab>` / `<Esc>[27;5;9~` | `<cmd>BufferNext<cr>` | Cycle to next tab (barbar.nvim) |
| **Normal** | `<C-S-Tab>` / `<Esc>[27;6;9~` | `<cmd>BufferPrevious<cr>` | Cycle to previous tab (barbar.nvim) |
| **Normal / Visual / Operator** | `s` | `require("flash").jump()` | Flash navigation search and label jump |
| **Normal / Visual / Operator** | `S` | `require("flash").treesitter()` | Flash Treesitter selection jump |
| **Operator** | `r` | `require("flash").remote()` | Remote Flash action |
| **Operator / Visual** | `R` | `require("flash").treesitter_search()` | Flash Treesitter search selection |
| **Command** | `<C-s>` | `require("flash").toggle()` | Toggle Flash search integration |
| **Normal** | `<leader>r` | Sourced function | Reload Neovim config (clears `package.loaded` for `config.*` and `plugins.*`) |
| **Normal** | `<leader>mt` | `<cmd>RenderMarkdown toggle<cr>` | Toggle Markdown render view on/off |
| **Normal** | `<leader>ag` | `toggle_agy_float(nil)` | Toggle floating `agy` CLI terminal |
| **Visual** | `<leader>ag` | `toggle_agy_float(payload)` | Send selected text with file & line context to floating `agy` terminal |
| **Normal** | `<leader>as` | `toggle_agy_sidebar(nil)` | Toggle right sidebar `agy` terminal |
| **Visual** | `<leader>as` | `toggle_agy_sidebar(payload)` | Send selected text with file & line context to sidebar `agy` terminal |
| **Normal** | `<leader>oc` | `toggle_opencode_float(nil)` | Toggle floating `opencode` CLI terminal |
| **Visual** | `<leader>oc` | `toggle_opencode_float(payload)` | Send selected text with file & line context to floating `opencode` terminal |
| **Normal** | `<leader>lg` | `<cmd>LazyGit<cr>` | Open Lazygit dashboard |
| **Normal** | `<leader>ld` | Sourced function | Open Lazygit directly in maximized full-screen Diff / Staging view |

---

## 3. Autocompletion (`lua/plugins/lsp.lua`)

Autocompletion is powered by `nvim-cmp`. 

| Mode | Keybinding | Action | Notes |
| :--- | :--- | :--- | :--- |
| **Insert** | `<C-Space>` | `cmp.mapping.complete()` | Triggers completion popup. Required Alacritty `chars = "\u0000"` mapping on Windows. |
| **Insert** | `<C-b>` / `<C-f>` | `cmp.mapping.scroll_docs()` | Scroll completion docs up / down. |
| **Insert** | `<C-e>` | `cmp.mapping.abort()` | Cancel completion popup. |
| **Insert** | `<CR>` | `cmp.mapping.confirm()` | Confirm selected completion item. |

---

## 4. Configuration Reloading

Simply running `:source $MYVIMRC` does **not** re-evaluate required Lua files due to Lua's `package.loaded` module caching. 

The custom `<leader>r` mapping handles this by clearing cached `config` and `plugins` modules before re-sourcing `init.lua`:

```lua
vim.keymap.set("n", "<leader>r", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^config") or name:match("^plugins") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC or vim.fn.stdpath("config") .. "/init.lua")
  local has_lazy, lazy = pcall(require, "lazy")
  if has_lazy and lazy.reload then
    pcall(lazy.reload, {})
  end
  vim.notify("Neovim config reloaded!", vim.log.levels.INFO)
end, { desc = 'Reload Neovim config' })
```
