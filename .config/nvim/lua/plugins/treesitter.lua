return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    -- The new module is singular 'config', not 'configs'
    local configs = require("nvim-treesitter.config")
    
    configs.setup({
        highlight = { enable = true },
        indent = { enable = true },
        -- 'ensure_installed' is now handled via require("nvim-treesitter").install
    })

    -- Install your preferred parsers smoothly
    require("nvim-treesitter").install({ "lua", "c", "vim", "fish" })
  end
}
