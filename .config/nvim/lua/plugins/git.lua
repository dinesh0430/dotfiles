return {
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",

			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- Optional dependency for better floating window support
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- Set the keybinding to open the Lazygit dashboard
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazygit" },
		},
	}
}
