local bind = vim.keymap.set

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.zenbones_lightness = "bright"
			vim.g.zenbones_darken_comments = 45
			vim.cmd.colorscheme("zenbones")
		end,
	},

	"https://codeberg.org/andyg/leap.nvim",

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
	},

	{ "nvim-tree/nvim-web-devicons", opts = {} },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- LSP
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	-- Autocompletion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-nvim-lsp",

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope-ui-select.nvim",

	"tpope/vim-surround",
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",
	{
		"akinsho/git-conflict.nvim",
		config = function()
			require("git-conflict").setup()
		end,
	},
	"karb94/neoscroll.nvim",
	"nvim-tree/nvim-tree.lua",
	"mfussenegger/nvim-lint",

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	"mhartington/formatter.nvim",

	{
		"zbirenbaum/copilot.lua",
		dependencies = { "copilotlsp-nvim/copilot-lsp" },
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept_word = "<M-w>",
					},
				},
				filetypes = {
					yaml = true,
					markdown = true,
					gitcommit = true,
					text = true,
				},
			})
		end,
	},

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		rocks = { enabled = false },
	},

	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},

	{
		"johmsalas/text-case.nvim",
		config = function()
			require("textcase").setup({})
		end,
	},

	{
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		opts = { global_keymaps = true },
	},
})

-- nvim-treesitter `main` has no highlight module; start it per buffer.
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

require("lualine").setup({
	options = {
		theme = "zenbones",
	},
})

bind({ "n", "x", "o" }, "s", "<Plug>(leap)")
bind("n", "S", "<Plug>(leap-from-window)")

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			bind(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk)
		map("n", "<leader>hr", gitsigns.reset_hunk)

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		map("n", "<leader>hS", gitsigns.stage_buffer)
		map("n", "<leader>hR", gitsigns.reset_buffer)
		map("n", "<leader>hp", gitsigns.preview_hunk)
		map("n", "<leader>hi", gitsigns.preview_hunk_inline)

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end)

		map("n", "<leader>hd", gitsigns.diffthis)

		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end)

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end)
		map("n", "<leader>hq", gitsigns.setqflist)

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
		map("n", "<leader>tw", gitsigns.toggle_word_diff)

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk)
	end,
})

require("neoscroll").setup({
	easing_function = "quadratic",
})

require("telescope").setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
bind("n", "<leader>ff", builtin.find_files)
bind("n", "<leader>fg", builtin.live_grep)
bind("n", "<leader>fb", builtin.buffers)
bind("n", "<leader>fh", builtin.help_tags)
bind("n", "<leader>fm", builtin.marks)
bind("n", "<leader>fq", builtin.quickfix)
bind("n", "<leader>fo", builtin.treesitter)
bind("n", "<leader>fr", builtin.lsp_references)
bind("n", "<leader>fc", builtin.command_history)

require("mason").setup()
-- Must run before servers are enabled.
vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
-- mason-lspconfig v2 calls vim.lsp.enable() for installed servers.
require("mason-lspconfig").setup()

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes"

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		bind("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		bind("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		bind("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		bind({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
	end,
})

vim.diagnostic.config({
	float = { focusable = true },
	-- Show the message after [d / ]d (old goto_prev/next did this by default).
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	},
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "buffer", group_index = 2 },
		{ name = "path", group_index = 3 },
		{ name = "luasnip", group_index = 4 },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		-- Accept currently selected item. Set `select` to `false` to only confirm
		-- explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
})

require("nvim-tree").setup()
local treeapi = require("nvim-tree.api")
bind("n", "<leader>e", function()
	treeapi.tree.toggle({ find_file = true })
end)

require("formatter").setup({
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		typescript = { require("formatter.filetypes.typescript").prettierd },
		typescriptreact = { require("formatter.filetypes.typescript").prettierd },
		javascript = { require("formatter.filetypes.javascript").prettierd },
		javascriptreact = { require("formatter.filetypes.javascript").prettierd },
		-- yaml = { require("formatter.filetypes.yaml").prettierd },
		json = { require("formatter.filetypes.json").prettierd },
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

require("lint").linters_by_ft = {
	markdown = { "vale" },
	typescript = { "eslint_d" },
	javascript = { "eslint_d" },
	yaml = { "yamllint", "actionlint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	json = { "jsonlint" },
}

autocmd("BufWritePost", {
	group = augroup("__lint__", { clear = true }),
	callback = function()
		require("lint").try_lint()
	end,
})

bind("n", "<leader>f", "mF:%!eslint_d --stdin --fix-to-stdout --stdin-filename %<CR>`F", { silent = true })

bind("n", "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
bind("v", "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
bind("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
vim.cmd([[cab cc CodeCompanion]])

require("codecompanion").setup({
	interactions = {
		chat = { adapter = "gemini" },
		inline = { adapter = "gemini" },
		cmd = { adapter = "gemini" },
	},
	adapters = {
		http = {
			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					env = { api_key = "cmd:cat $HOME/.gemini-api-key" },
				})
			end,
		},
		acp = {
			gemini_cli = function()
				return require("codecompanion.adapters").extend("gemini_cli", {
					env = { GEMINI_API_KEY = "cmd:cat $HOME/.gemini-api-key" },
				})
			end,
			claude_code = function()
				return require("codecompanion.adapters").extend("claude_code", {
					env = {
						CLAUDE_CODE_OAUTH_TOKEN = "cmd:jq -r '.claudeAiOauth.accessToken' ~/.claude/.credentials.json",
					},
				})
			end,
		},
	},
})
