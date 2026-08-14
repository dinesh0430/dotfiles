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
		keys = (function()
			local function open_lazygit(keystrokes)
				local utils = require("lazygit.utils")
				if not utils.is_lazygit_available() then
					vim.notify("Lazygit is not installed", vim.log.levels.ERROR)
					return
				end

				local home = vim.env.HOME or vim.fn.expand("~")
				local dotfiles_git_dir = home .. "/.config/.git"
				local current_dir = vim.fn.expand("%:p:h")
				if current_dir == "" or vim.bo.buftype == "terminal" then
					current_dir = vim.fn.getcwd()
				end

				local cmd = { "lazygit" }

				if vim.env.GIT_DIR and vim.env.GIT_WORK_TREE then
					table.insert(cmd, "-w")
					table.insert(cmd, vim.env.GIT_WORK_TREE)
					table.insert(cmd, "-g")
					table.insert(cmd, vim.env.GIT_DIR)
				else
					local is_bare = vim.trim(vim.fn.system("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --is-bare-repository 2>/dev/null"))
					local git_dir = vim.trim(vim.fn.system("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --git-dir 2>/dev/null"))
					if git_dir == dotfiles_git_dir or (is_bare == "true" and vim.fn.isdirectory(dotfiles_git_dir) == 1) then
						table.insert(cmd, "-w")
						table.insert(cmd, home)
						table.insert(cmd, "-g")
						table.insert(cmd, dotfiles_git_dir)
					end
				end

				local win_mod = require("lazygit.window")
				local prev_win = vim.api.nvim_get_current_win()
				local win, buf = win_mod.open_floating_window()

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

				if keystrokes and keystrokes ~= "" then
					vim.defer_fn(function()
						pcall(vim.fn.chansend, job_id, keystrokes)
					end, 200)
				end

				vim.cmd("startinsert")
			end

			return {
				{
					"<leader>lg",
					function()
						open_lazygit(nil)
					end,
					desc = "Open lazygit",
				},
				{
					"<leader>ld",
					function()
						open_lazygit("\r+0|")
					end,
					desc = "Lazygit diff view (maximized)",
				},
			}
		end)(),
	}
}
