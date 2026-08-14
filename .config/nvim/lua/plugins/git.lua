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
		init = function()
			-- Maximize floating window to fit the screen
			vim.g.lazygit_floating_window_scaling_factor = 0.98
			vim.g.lazygit_floating_window_winblend = 0
		end,
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazygit" },
			{
				"<leader>ld",
				function()
					local utils = require("lazygit.utils")
					if not utils.is_lazygit_available() then
						vim.notify("Lazygit is not installed", vim.log.levels.ERROR)
						return
					end

					local win_mod = require("lazygit.window")
					local prev_win = vim.api.nvim_get_current_win()
					local win, buf = win_mod.open_floating_window()

					local cmd = { "lazygit" }

					if vim.env.GIT_DIR and vim.env.GIT_WORK_TREE then
						table.insert(cmd, "-w")
						table.insert(cmd, vim.env.GIT_WORK_TREE)
						table.insert(cmd, "-g")
						table.insert(cmd, vim.env.GIT_DIR)
					end

					local job_id = vim.fn.jobstart(cmd, {
						term = true,
						on_exit = function()
							vim.cmd("silent! :checktime")
							if vim.api.nvim_win_is_valid(win) then
								vim.api.nvim_win_close(win, true)
							end
							if vim.api.nvim_win_is_valid(prev_win) then
								vim.api.nvim_set_current_win(prev_win)
							end
							if vim.api.nvim_buf_is_valid(buf) then
								vim.api.nvim_buf_delete(buf, { force = true })
							end
						end,
					})

					-- Send <Enter> (staging/diff), '+' (maximize), '0' (focus diff view), '|' (cycle diff renderer)
					-- with a 200ms delay so Lazygit has finished loading git status
					vim.defer_fn(function()
						pcall(vim.fn.chansend, job_id, "\r+0|")
					end, 200)

					vim.cmd("startinsert")
				end,
				desc = "Lazygit diff view (maximized)",
			},
		},
	}
}
