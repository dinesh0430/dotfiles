return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
	'nvim-lua/plenary.nvim',
	-- optional but recommended
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>fF', function()
		builtin.find_files({ hidden = true, no_ignore = true })
	end, { desc = 'Telescope find all files (hidden & ignored)' })

	vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fG', function()
		builtin.live_grep({
			additional_args = function()
				return { '--hidden', '--no-ignore', '--glob=!.git/' }
			end,
		})
	end, { desc = 'Telescope live grep all (hidden & ignored)' })

	vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
}
