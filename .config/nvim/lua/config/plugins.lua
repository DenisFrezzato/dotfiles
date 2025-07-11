local bind = vim.keymap.set

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
	"wbthomason/packer.nvim",
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

	"ggandor/leap.nvim",

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
	},

	{ "nvim-tree/nvim-web-devicons", opts = {} },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
	},

	"hrsh7th/nvim-cmp",

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",

			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sharkdp/fd",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"nvim-telescope/telescope-ui-select.nvim",

	"editorconfig/editorconfig-vim",
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
		cmd = "Copilot",
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
			{ "stevearc/dressing.nvim", opts = {} },
		},
		config = true,
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
})

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
})

vim.opt.background = "light"

require("lualine").setup({
	options = {
		theme = "zenbones",
	},
})

require("leap").set_default_mappings()

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
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
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes"

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		bind("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		bind("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		bind("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		bind("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		bind({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
	end,
})

vim.diagnostic.config({
	float = { focusable = true },
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

require("lsp-file-operations").setup()

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
	callback = function()
		require("lint").try_lint()
	end,
})

bind(
	"n",
	"<leader>f",
	"<cmd>mF:%!eslint_d --stdin --fix-to-stdout --stdin-filename %<CR>`F",
	{ noremap = true, silent = true }
)

-- bind("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- bind("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
bind("n", "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
bind("v", "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
bind("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
vim.cmd([[cab cc CodeCompanion]])
