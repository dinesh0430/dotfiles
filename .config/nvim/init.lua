require('config.options')
require('config.keybinds')
require('config.lazy')

vim.opt.termguicolors = true
require("bufferline").setup {}

vim.opt.winborder = 'rounded'
vim.opt.clipboard = "unnamedplus"

-- Change the cursor behavior for active modes
vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor",
	"sm:block-blinkwait175-blinkoff150-blinkon175"
}

-- Handle cursor shapes on Enter and Exit using stdout writes
vim.api.nvim_create_autocmd("VimEnter", {
	command = 'silent !echo -ne "\\e[3 q"'
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		io.write("\x1b[3 q")            -- Underline cursor
		io.write("\x1b]50;CursorShape=1\x07") -- iTerm2/Konsole specific cursor reset
		io.write("\x1b[5 q")            -- VT100/Xterm standard bar cursor reset
		vim.opt.guicursor = "a:ver25-blinkon250"
	end
})

local float_buf = nil
local float_win = nil

-- Helper to calculate responsive floating window dimensions
local function get_win_opts()
	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.8)
	return {
		relative = 'editor',
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = 'minimal',
		border = 'rounded'
	}
end

-- The main toggle function for the float window
local function toggle_agy_float(text_to_paste)
	-- 1. If window is open and we are NOT pasting text, hide it (toggle behavior)
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		if not text_to_paste then
			vim.api.nvim_win_close(float_win, true)
			float_win = nil
			return
		else
			-- If window is open and we are pasting, make sure it is focused
			vim.api.nvim_set_current_win(float_win)
		end
	end

	-- 2. Create the persistent buffer if it doesn't exist or was killed
	if not float_buf or not vim.api.nvim_buf_is_valid(float_buf) then
		float_buf = vim.api.nvim_create_buf(false, true)
		-- Open the window first to establish terminal dimensions
		float_win = vim.api.nvim_open_win(float_buf, true, get_win_opts())

		-- Setup buffer-local keymap to close floating window from inside terminal
		vim.keymap.set('t', '<Esc><Esc>', function()
			if float_win and vim.api.nvim_win_is_valid(float_win) then
				vim.api.nvim_win_close(float_win, true)
				float_win = nil
			end
		end, { buffer = float_buf, desc = "Hide agy float from inside terminal" })

		-- Start the job inside the terminal buffer using the non-deprecated jobstart
		vim.api.nvim_buf_call(float_buf, function()
			vim.fn.jobstart({ 'agy' }, {
				term = true,
				on_exit = function()
					if float_win and vim.api.nvim_win_is_valid(float_win) then
						vim.api.nvim_win_close(float_win, true)
					end
					float_buf = nil
					float_win = nil
				end
			})
		end)
	else
		-- Buffer exists, reopen the window pointing to it (if not already open)
		if not float_win or not vim.api.nvim_win_is_valid(float_win) then
			float_win = vim.api.nvim_open_win(float_buf, true, get_win_opts())
		end
	end

	-- 3. If text was passed from a visual selection, send it to the terminal channel
	if text_to_paste then
		-- Small delay ensures the terminal is fully ready to accept input
		vim.defer_fn(function()
			local chans = vim.api.nvim_list_chans()
			for _, chan in ipairs(chans) do
				if chan.buffer == float_buf then
					vim.api.nvim_chan_send(chan.id, text_to_paste)
					break
				end
			end
		end, 50)
	end

	vim.cmd('startinsert')
end

-- Keymap 1: Normal mode toggle (Hide / Unhide Float Window)
vim.keymap.set('n', '<leader>ag', function() toggle_agy_float(nil) end, { desc = "Toggle agy float window" })

-- Keymap 2: Visual mode selection sender to Float Window
vim.keymap.set('v', '<leader>ag', function()
	-- Save registry state politely
	local old_reg = vim.fn.getreg('v')
	local old_regtype = vim.fn.getregtype('v')

	vim.cmd('normal! "vy')
	local text = vim.fn.getreg('v')

	-- Restore registry state
	vim.fn.setreg('v', old_reg, old_regtype)

	-- Exit visual mode cleanly
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'n', true)

	-- Open agy and paste the text
	toggle_agy_float(text)
end, { desc = "Send selection to agy float window" })


local sidebar_buf = nil
local sidebar_win = nil
local sidebar_width = 55 -- Set your preferred sidebar width in columns

-- The main toggle function for the sidebar
local function toggle_agy_sidebar(text_to_paste)
	-- 1. If sidebar window is open and we are NOT pasting text, close/hide it
	if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
		if not text_to_paste then
			vim.api.nvim_win_close(sidebar_win, true)
			sidebar_win = nil
			return
		else
			-- If window is open and we are pasting, make sure it is focused
			vim.api.nvim_set_current_win(sidebar_win)
		end
	end

	-- 2. Create the persistent buffer if it doesn't exist or was killed
	if not sidebar_buf or not vim.api.nvim_buf_is_valid(sidebar_buf) then
		sidebar_buf = vim.api.nvim_create_buf(false, true)

		-- Open vertical split on the far right
		vim.cmd("botright " .. sidebar_width .. "vsplit")
		sidebar_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(sidebar_win, sidebar_buf)

		-- Configure sidebar window options
		vim.wo[sidebar_win].number = false
		vim.wo[sidebar_win].relativenumber = false
		vim.wo[sidebar_win].signcolumn = "no"
		vim.wo[sidebar_win].winfixwidth = true

		-- Setup buffer-local keymap to close sidebar window from inside terminal
		vim.keymap.set('t', '<Esc><Esc>', function()
			if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
				vim.api.nvim_win_close(sidebar_win, true)
				sidebar_win = nil
			end
		end, { buffer = sidebar_buf, desc = "Hide agy sidebar from inside terminal" })

		-- Start the job inside the terminal buffer using the non-deprecated jobstart
		vim.api.nvim_buf_call(sidebar_buf, function()
			vim.fn.jobstart({ 'agy' }, {
				term = true,
				on_exit = function()
					if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
						vim.api.nvim_win_close(sidebar_win, true)
					end
					sidebar_buf = nil
					sidebar_win = nil
				end
			})
		end)
	else
		-- Buffer exists, reopen the sidebar window pointing to it (if not already open)
		if not sidebar_win or not vim.api.nvim_win_is_valid(sidebar_win) then
			vim.cmd("botright " .. sidebar_width .. "vsplit")
			sidebar_win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(sidebar_win, sidebar_buf)

			-- Maintain clean sidebar options on re-open
			vim.wo[sidebar_win].number = false
			vim.wo[sidebar_win].relativenumber = false
			vim.wo[sidebar_win].signcolumn = "no"
			vim.wo[sidebar_win].winfixwidth = true
		end
	end

	-- 3. If text was passed from a visual selection, feed it to the terminal channel
	if text_to_paste then
		vim.defer_fn(function()
			local chans = vim.api.nvim_list_chans()
			for _, chan in ipairs(chans) do
				if chan.buffer == sidebar_buf then
					vim.api.nvim_chan_send(chan.id, text_to_paste)
					break
				end
			end
		end, 50)
	end

	vim.cmd('startinsert')
end

-- Keymap 1: Normal mode toggle (Open / Hide Right Sidebar)
vim.keymap.set('n', '<leader>as', function() toggle_agy_sidebar(nil) end, { desc = "Toggle agy sidebar" })

-- Keymap 2: Visual mode selection sender to Sidebar
vim.keymap.set('v', '<leader>as', function()
	-- Save registry state politely
	local old_reg = vim.fn.getreg('v')
	local old_regtype = vim.fn.getregtype('v')

	vim.cmd('normal! "vy')
	local text = vim.fn.getreg('v')

	-- Restore registry state
	vim.fn.setreg('v', old_reg, old_regtype)

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'n', true)
	toggle_agy_sidebar(text)
end, { desc = "Send selection to agy sidebar" })
