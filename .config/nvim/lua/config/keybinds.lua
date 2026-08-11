vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", "<cmd>NvimTreeToggle<cr>", { desc = 'Toggle NvimTree' })
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = 'Clear search highlighting' })

-- Cycle between open tabs/buffers
-- NOTE FOR ALACRITTY USERS:
-- Most terminals (including Alacritty) swallow Ctrl+Tab by default or send a regular Tab character (\t).
-- To make Ctrl+Tab and Ctrl+Shift+Tab work, add the following to your `alacritty.toml` (v0.13+):
--   [[keyboard.bindings]]
--   key = "Tab"
--   mods = "Control"
--   chars = "\u001b[27;5;9~"
--
--   [[keyboard.bindings]]
--   key = "Tab"
--   mods = "Control|Shift"
--   chars = "\u001b[27;6;9~"
vim.keymap.set("n", "<C-Tab>", "<cmd>BufferNext<cr>", { desc = 'Next tab' })
vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferPrevious<cr>", { desc = 'Previous tab' })
vim.keymap.set("n", "<Esc>[27;5;9~", "<cmd>BufferNext<cr>", { desc = 'Next tab (Alacritty)' })
vim.keymap.set("n", "<Esc>[27;6;9~", "<cmd>BufferPrevious<cr>", { desc = 'Previous tab (Alacritty)' })

-- Reload Neovim config with cache clearing
vim.keymap.set("n", "<leader>r", function()
  -- 1. Unload cached custom lua modules under config/ and plugins/
  for name, _ in pairs(package.loaded) do
    if name:match("^config") or name:match("^plugins") then
      package.loaded[name] = nil
    end
  end

  -- 2. Re-evaluate init.lua
  dofile(vim.env.MYVIMRC or vim.fn.stdpath("config") .. "/init.lua")

  -- 3. Safely reload lazy.nvim specs if needed
  local has_lazy, lazy = pcall(require, "lazy")
  if has_lazy and lazy.reload then
    pcall(lazy.reload, {})
  end

  vim.notify("Neovim config reloaded!", vim.log.levels.INFO)
end, { desc = 'Reload Neovim config' })
