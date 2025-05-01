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
	"olimorris/onedarkpro.nvim",

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

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
	"nvim-telescope/telescope-ui-select.nvim",

	"editorconfig/editorconfig-vim",
	"tpope/vim-surround",
	"airblade/vim-gitgutter",
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

	"mhartington/formatter.nvim",

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { auto_trigger = true, keymap = {
					accept_word = "<M-w>",
				} },
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

	"adelarsq/neofsharp.vim",
})

require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
})

pcall(vim.cmd, "colorscheme onelight")

require("lualine").setup({
	options = { theme = "onelight" },
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
bind({ "n", "v" }, "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<cr>")

local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
	bind("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr })
end)

lsp.setup()

vim.diagnostic.config({
	float = { focusable = true },
})

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "buffer", group_index = 2 },
		{ name = "path", group_index = 3 },
		{ name = "luasnip", group_index = 4 },
	},
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

vim.api.nvim_set_keymap(
	"n",
	"<leader>f",
	"<cmd>mF:%!eslint_d --stdin --fix-to-stdout --stdin-filename %<CR>`F",
	{ noremap = true, silent = true }
)

-- vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
