return {
	-- 1. Declare the nvim-cmp autocompletion engine and its sources
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({

				window = {
					completion = cmp.config.window.bordered({
						border = 'rounded',
					}),
					documentation = cmp.config.window.bordered({
						border = 'rounded',
					}),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),

					-- Manually trigger completion menu
					-- NOTE FOR ALACRITTY USERS:
					-- Alacritty sends standard Space or NUL on Ctrl+Space by default.
					-- To make Ctrl+Space trigger nvim-cmp reliably, add to `alacritty.toml`:
					--   [[keyboard.bindings]]
					--   key = "Space"
					--   mods = "Control"
					--   chars = "\u0000"
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
				}),
				-- Order of completion sources matters for ranking suggestions

				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- Language server suggestions (QMK keycodes, Rust types)
					{ name = "path" }, -- File system paths
					{ name = "buffer" }, -- Words from open buffers
				}),
			})
		end,
	},

	-- 2. Modern Native LSP Setup (Neovim 0.11+)
	{
		"neovim/nvim-lspconfig", -- We don't call .setup() with this, but it makes servers discoverable via vim.lsp.config
		config = function()
			-- Establish global defaults for root markers
			vim.lsp.config('*', {
				root_markers = { '.git' },
			})

			-- UI Styling for diagnostics (Icons and floating windows)
			vim.diagnostic.config({
				virtual_text  = true,
				severity_sort = true,
				float         = {
					style  = 'minimal',
					border = 'rounded',
					source = 'if_many',
					header = '',
					prefix = '',
				},
				signs         = {
					text = {
						[vim.diagnostic.severity.ERROR] = '✘',
						[vim.diagnostic.severity.WARN]  = '▲',
						[vim.diagnostic.severity.HINT]  = '⚑',
						[vim.diagnostic.severity.INFO]  = '»',
					},
				},
			})

			-- Style global floating previews (like 'K' documentation hover)
			local orig = vim.lsp.util.open_floating_preview
			---@diagnostic disable-next-line: duplicate-set-field
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts            = opts or {}

				opts.border     = opts.border or 'rounded'
				opts.max_width  = opts.max_width or 80

				opts.max_height = opts.max_height or 24
				opts.wrap       = opts.wrap ~= false
				return orig(contents, syntax, opts, ...)
			end

			-- Central Attach function for defining keymaps, highlights, and formatting
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('my.lsp', {}),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					local buf    = args.buf
					local map    = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

					-- Keymaps
					map('n', 'K', vim.lsp.buf.hover)
					map('n', 'gd', vim.lsp.buf.definition)
					map('n', 'gD', vim.lsp.buf.declaration)
					map('n', 'gi', vim.lsp.buf.implementation)
					map('n', 'go', vim.lsp.buf.type_definition)
					map('n', 'gr', vim.lsp.buf.references)
					map('n', 'gs', vim.lsp.buf.signature_help)
					map('n', 'gl', vim.diagnostic.open_float)
					map('n', '<F2>', vim.lsp.buf.rename)
					map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
					map('n', '<F4>', vim.lsp.buf.code_action)

					-- Document Highlight when holding cursor over symbol
					if client:supports_method('textDocument/documentHighlight') then
						local highlight_augroup = vim.api.nvim_create_augroup('my.lsp.highlight', { clear = false })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {

							buffer = buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- Format on Save configuration (Skips C/C++ so it doesn't fight QMK formatting styles)
					local excluded_filetypes = { php = true, c = true, cpp = true }
					if not client:supports_method('textDocument/willSaveWaitUntil')
						and client:supports_method('textDocument/formatting')

						and not excluded_filetypes[vim.bo[buf].filetype]
					then
						vim.api.nvim_create_autocmd('BufWritePre', {
							group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
							buffer = buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
							end,
						})
					end
				end,
			})

			-- Feed the completion capabilities from cmp into the native configs
			local caps = require("cmp_nvim_lsp").default_capabilities()

			-- Server Definition 1: Lua Language Server
			vim.lsp.config['luals'] = {
				cmd = { 'lua-language-server' },
				filetypes = { 'lua' },
				root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
				capabilities = caps,
				settings = {

					Lua = {
						runtime = { version = 'LuaJIT' },
						diagnostics = { globals = { 'vim' } }, -- Ignores 'vim' global undefined warnings
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file('', true), -- Injects Neovim APIs for completion
						},
						telemetry = { enable = false },
					},
				},
			}

			-- Server Definition 2: Rust Analyzer
			vim.lsp.config['rust_analyzer'] = {
				cmd = { 'rust-analyzer' },
				filetypes = { 'rust' },
				root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
				capabilities = caps,
				settings = {
					['rust-analyzer'] = {
						cargo = { allFeatures = true },
						formatting = { command = { "rustfmt" } },
					},
				},
			}

			-- Server Definition 3: Clangd for QMK (C/C++)
			vim.lsp.config['clangd'] = {
				cmd = {
					'clangd',
					'--background-index',
					'--clang-tidy',

					'--header-insertion=never',

				},
				filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
				root_markers = { 'compile_commands.json', '.clangd', 'Makefile', '.git' },
				capabilities = caps,
			}

			-- Auto-enable all configured servers
			---@diagnostic disable-next-line: invisible
			for name, _ in pairs(vim.lsp.config._configs) do
				if name ~= '*' then
					vim.lsp.enable(name)
				end
			end
		end,
	},
}
