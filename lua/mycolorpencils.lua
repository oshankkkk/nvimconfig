-- vim.lsp.set_log_level("debug") -- left off: this writes a verbose log every session and slows startup.
-- Uncomment temporarily (or run :lua vim.lsp.set_log_level("debug") ad-hoc) only when you're actively
-- debugging an LSP issue, and check the log with :LspLog.

-- Leader keys must be set before lazy.nvim loads.
vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false


vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 999

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--this says either vim.uv or vim.loop
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
	lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("lazy").setup({
	--it goes like setup({plugins},{options})
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"lervag/vimtex",
		lazy = false, -- VimTeX recommends not lazy-loading
		init = function()
			vim.g.vimtex_view_method = "zathura" -- Linux
		end,
	},

	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
		dependencies = {
			-- include a picker of your choice, see picker section for more details
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			-- configuration goes here
			{
				---@type string
				arg = "leetcode.nvim",

				---@type lc.lang
				lang = "python",

				cn = { -- leetcode.cn
					enabled = false, ---@type boolean
					translator = true, ---@type boolean
					translate_problems = true, ---@type boolean
				},

				---@type lc.storage
				storage = {
					home = vim.fn.stdpath("data") .. "/leetcode",
					cache = vim.fn.stdpath("cache") .. "/leetcode",
				},

				---@type table<string, boolean>
				plugins = {
					non_standalone = false,
				},

				---@type boolean
				logging = true,

				injector = {}, ---@type table<lc.lang, lc.inject>

				cache = {
					update_interval = 60 * 60 * 24 * 7, ---@type integer 7 days
				},

				editor = {
					reset_previous_code = true, ---@type boolean
					fold_imports = true, ---@type boolean
				},

				console = {
					open_on_runcode = true, ---@type boolean

					dir = "row", ---@type lc.direction

					size = { ---@type lc.size
						width = "90%",
						height = "75%",
					},

					result = {
						size = "60%", ---@type lc.size
					},

					testcase = {
						virt_text = true, ---@type boolean

						size = "40%", ---@type lc.size
					},
				},

				description = {
					position = "left", ---@type lc.position

					width = "40%", ---@type lc.size

					show_stats = true, ---@type boolean
				},

				---@type lc.picker
				picker = { provider = nil },

				hooks = {
					---@type fun()[]
					["enter"] = {},

					---@type fun(question: lc.ui.Question)[]
					["question_enter"] = {},

					---@type fun()[]
					["leave"] = {},
				},

				keys = {
					toggle = { "q" }, ---@type string|string[]
					confirm = { "<CR>" }, ---@type string|string[]

					reset_testcases = "r", ---@type string
					use_testcase = "U", ---@type string
					focus_testcases = "H", ---@type string
					focus_result = "L", ---@type string
				},

				---@type lc.highlights
				theme = {},

				---@type boolean
				image_support = false,
			}
		},
	},

	{
		'sindrets/diffview.nvim'
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup()
		end,
	},

	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	{
		'nvim-telescope/telescope.nvim', version = '*',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- optional but recommended
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
			})

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		end,
	},

	-- NOTE: nvim-treesitter's `master` branch (the old ensure_installed/highlight.enable API)
	-- is now frozen; all development happens on `main`, which is a full rewrite and requires
	-- Neovim 0.12+. Parsers are installed explicitly and highlighting is enabled per-filetype
	-- via an autocmd instead of a config flag. `auto_install` no longer exists on `main` --
	-- add any new language to BOTH the install() list and the autocmd pattern below.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- the `main` branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			local languages = { "c", "lua", "vim", "vimdoc", "query" }

			require("nvim-treesitter").install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = languages,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			"obsidian-nvim/obsidian.nvim",
			version = "*", -- use latest release, remove to use latest commit
			---@module 'obsidian'
			---@type obsidian.config
			opts = {
				legacy_commands = false, -- this will be removed in 4.0.0
				workspaces = {
					{
						name = "personal",
						path = "~/Documents/Obsidian Vault",
					},
				},
			},
			config = function(_, opts)
				require("obsidian").setup(opts)

				vim.api.nvim_create_user_command("Obsnew", "Obsidian new", {})
				vim.api.nvim_create_user_command("Obsls", "Obsidian quick_switch", {})
				vim.api.nvim_create_user_command("Obstdy", "Obsidian today", {})
				vim.api.nvim_create_user_command("Obsfind", "Obsidian search", {})
			end,
		},
		-- i dont need mason cause all my LSPs are inside nix-shells
		--
		--mason 
		{
			"mason-org/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			},
			config = function()
				require("mason").setup()
			end,
		},
		{
			"neovim/nvim-lspconfig",
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"sphamba/smear-cursor.nvim",

			opts = {
				-- Smear cursor when switching buffers or windows.
				smear_between_buffers = true,

				-- Smear cursor when moving within line or to neighbor lines.
				-- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
				smear_between_neighbor_lines = true,

				-- Draw the smear in buffer space instead of screen space when scrolling
				scroll_buffer_space = true,

				-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
				-- Smears and particles will look a lot less blocky.
				legacy_computing_symbols_support = false,

				-- Smear cursor in insert mode.
				-- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
				smear_insert_mode = true,
			},
		},
		--neoscroll makes my eyes hurt
		--        {
			--            "karb94/neoscroll.nvim",
			--            opts = {
				--                mappings = {
					--                    "<C-u>", "<C-d>",
					--                    "<C-b>", "<C-f>",
					--                    "<C-y>", "<C-e>",
					--                    "zt", "zz", "zb",
					--                },
					--                hide_cursor = true,
					--                stop_eof = true,
					--                respect_scrolloff = false,
					--                cursor_scrolls_alone = true,
					--                duration_multiplier = 1.0,
					--                easing = "linear",
					--                pre_hook = nil,
					--                post_hook = nil,
					--                performance_mode = false,
					--                ignored_events = {
						--                    "WinScrolled",
						--                    "CursorMoved",
						--                },
						--            },
						--        },
						--
						{
							'saghen/blink.cmp',
							-- optional: provides snippets for the snippet source
							dependencies = { 'rafamadriz/friendly-snippets' },

							version = '1.*',
							opts = {

								keymap = { preset = 'default' },

								appearance = {
									nerd_font_variant = 'mono'
								},

								signature = {
								  enabled = true,
								},
								-- (Default) Only show the documentation popup when manually triggered
								completion = { documentation = { auto_show = true } },
								-- See the fuzzy documentation for more information
								fuzzy = { implementation = "prefer_rust_with_warning" },
								sources = {
									-- add lazydev to your completion providers
									default = { "lazydev", "lsp", "path", "snippets", "buffer" },
									providers = {
										lazydev = {
											name = "LazyDev",
											module = "lazydev.integrations.blink",
											-- make lazydev completions top priority (see `:h blink.cmp`)
											score_offset = 100,
										},
									},
								},
							},
							opts_extend = { "sources.default" }
						},
						-- blink conifg end
						},
					-- Configure any other settings here. See the documentation for more details.
					-- colorscheme that will be used when installing plugins.
					{ 
						install = { colorscheme = { "habamax" } },
						-- automatically check for plugin updates
						checker = { enabled = true },
					}
				)

-- Keymaps
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
--vim.keymap.set('n', '<leader>e', '<cmd>Telescope find_files<cr>', { desc = 'Telescope Find Files' })
vim.keymap.set('n', '<leader>t', '<cmd>Telescope find_files<cr>', { desc = 'Telescope Find Files' })
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Write and quit" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {
	desc = "Clear search highlight",
	silent = true,
})

-- LSP
vim.lsp.enable("pyright")
vim.lsp.enable("emmylua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("sqlls")
vim.lsp.enable("gopls")
vim.lsp.enable("clangd")

-- LSP keybindings
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })

-- Diagnostic keybindings
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

-- Debugger keybindings
local dap = require("dap")
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dr", dap.repl.open)

-- Markdown line wrap
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
	end,
})
