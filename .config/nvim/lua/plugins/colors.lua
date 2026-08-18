return {
    {
	"rebelot/kanagawa.nvim", -- Also check out https://github.com/navarasu/onedark.nvim
	config = function()
		require("kanagawa").setup({
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = theme.ui.bg_m1 },
					FloatBorder = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					FloatTitle = { fg = theme.ui.fg, bg = theme.ui.bg_m1, bold = true },

					-- Style cmp menu/documentation to match
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
				}
			end,
		})
		vim.cmd("colorscheme kanagawa")
	end
    },
    {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	opts = {
	    options = {
		theme = 'auto',
		section_separators = { left = '', right = '' },
		component_separators = { left = '|', right = '|' },
	    },
	}
    }
}
