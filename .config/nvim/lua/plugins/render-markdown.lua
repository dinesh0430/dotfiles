return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    -- Disable anti_conceal to prevent revealing raw markdown formatting on the current line
    anti_conceal = {
      enabled = false,
    },
  },
  ft = { 'markdown' },
  keys = {
    { '<leader>mt', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle Markdown Render' },
  },
}

