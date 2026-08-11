return {
  "olimorris/persisted.nvim",
  lazy = false,
  opts = {
    autostart = true,
  },
  config = function(_, opts)
    local persisted = require("persisted")
    persisted.setup(opts)

    pcall(function()
      require("telescope").load_extension("persisted")
    end)
  end,
  keys = {
    { "<leader>qs", "<cmd>Persisted load<cr>", desc = "Restore Session (Current Dir)" },
    { "<leader>qS", "<cmd>Telescope persisted<cr>", desc = "Select/Search Sessions (Telescope)" },
    { "<leader>ql", "<cmd>Persisted loadLast<cr>", desc = "Restore Last Session" },
    { "<leader>qn", "<cmd>PersistedSave<cr>", desc = "Save Named Session" },
    { "<leader>qd", "<cmd>PersistedStop<cr>", desc = "Don't Save Current Session" },
  },
}

