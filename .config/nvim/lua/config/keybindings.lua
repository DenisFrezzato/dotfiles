local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

bind("n", "<leader>w", ":w<cr>", opts)
bind("n", "<leader>q", ":q<cr>", opts)
bind({ "n", "v" }, "<leader><cr>", ":noh<cr>", { silent = true }, opts)
bind({ "n", "v" }, "<leader>ss", "<cmd>setlocal spell!<cr>", opts)

-- Clipboard functionality (paste from system).
bind({ "n", "v" }, "<leader>y", '"+y', opts)
bind({ "n", "v" }, "<leader>p", '"+p', opts)

-- Quickly move current line up or down.
-- Stolen from https://vimtricks.com/p/vimtrick-moving-lines/.
bind("n", "<c-j>", "<cmd>m .+1<cr>==", opts)
bind("n", "<c-k>", "<cmd>m .-2<cr>==", opts)

-- Base64 encode/decode
bind("v", "<leader>64e", "y:let @\"=system('base64 -w 0', @\")<cr>gvP", opts)
bind("v", "<leader>64d", "y:let @\"=system('base64 -w 0 --decode', @\")<cr>gvP", opts)

bind("n", "[d", vim.diagnostic.goto_prev, opts)
bind("n", "]d", vim.diagnostic.goto_next, opts)
bind("n", "<leader>k", vim.lsp.buf.signature_help, opts)

bind("n", "gK", function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
