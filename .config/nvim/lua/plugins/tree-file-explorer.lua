-- 1. Disable netrw at the very start (placed outside the return table so it runs immediately)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 2. Optionally enable 24-bit color
vim.opt.termguicolors = true

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",

  lazy = false,
  dependencies = {

    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- 3. Pass your custom configuration options into the setup function
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",

      },
      view = {
        width = 30,
      },

      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })

  end,
}
