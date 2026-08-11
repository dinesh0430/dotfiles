return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        function()
          return {
            icon = " ",
            title = "PWD: " .. vim.fn.getcwd(),
            padding = 1,
          }
        end,
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
          { icon = " ", key = "c", desc = "Config", action = ":Telescope find_files cwd=" .. vim.fn.stdpath("config") },
          { icon = " ", key = "s", desc = "Restore Session", action = function() require("persisted").load() end },
          { icon = "󰒲 ", key = "l", desc = "Lazy Plugins", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit Neovim", action = ":qa" },
        },
      },
    },
  },
}
