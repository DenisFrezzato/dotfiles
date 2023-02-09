local bind = vim.keymap.set

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("olimorris/onedarkpro.nvim")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		requires = {
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
	})

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = {
			"nvim-lua/plenary.nvim",
			"sharkdp/fd",
			"nvim-treesitter/nvim-treesitter",
		},
	})

	use("editorconfig/editorconfig-vim")
	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("airblade/vim-gitgutter")
	use("tpope/vim-fugitive")
	use("karb94/neoscroll.nvim")
	use("nvim-tree/nvim-tree.lua")

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use("jay-babu/mason-null-ls.nvim")
	use({
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
	})

	use("mhartington/formatter.nvim")
end)

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

local builtin = require("telescope.builtin")
bind("n", "<leader>ff", builtin.find_files)
bind("n", "<leader>fg", builtin.live_grep)
bind("n", "<leader>fb", builtin.buffers)
bind("n", "<leader>fh", builtin.help_tags)
bind("n", "<leader>fm", builtin.marks)
bind("n", "<leader>fq", builtin.quickfix)
bind("n", "<leader>fo", builtin.treesitter)

local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
	bind("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = bufnr })
end)

lsp.setup()

vim.diagnostic.config({
	float = { focusable = true },
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
		javascript = { require("formatter.filetypes.javascript").prettierd },
		yaml = { require("formatter.filetypes.yaml").prettierd },
		json = { require("formatter.filetypes.json").prettierd },
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *\(.json\)\@<! FormatWrite
augroup END
]],
	true
)

require("mason-null-ls").setup({
	ensure_installed = { "prettierd", "eslint_d" },
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.completion.spell,
		null_ls.builtins.code_actions.cspell,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.code_actions.gitrebase,
		null_ls.builtins.diagnostics.tsc,
		null_ls.builtins.diagnostics.actionlint,
	},
})

bind({ "n", "v" }, "<leader>ac", "<cmd>:CodeActionMenu<cr>")
