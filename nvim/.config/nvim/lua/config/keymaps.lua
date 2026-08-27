local opts = { noremap = true, silent = true }

-- Disable Space in normal/visual (it's leader)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Change word under cursor, press . to repeat
vim.keymap.set("n", "cn", "*``cgn", opts)
vim.keymap.set("n", "cN", "*``cgN", opts)

-- Clipboard
vim.keymap.set("n", "<leader>y", '"+yy', opts)
vim.keymap.set("n", "<leader>Y", '"+y$', opts)
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>p", '"+p', opts)

-- File
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", opts)

-- Insert blank line without entering insert mode
vim.keymap.set("n", "<S-CR>", "o<Esc>", opts)

-- Clear highlights
vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>", opts)

-- Buffer navigation
vim.keymap.set("n", "<leader><leader>", "<cmd>b#<cr>", opts)
vim.keymap.set("n", "bb", ":ls<CR>:b<Space>", { noremap = true, silent = false })-- Also setup in fzf <fb>
vim.keymap.set("n", "bp", "<cmd>bp<cr>", opts)
vim.keymap.set("n", "bn", "<cmd>bn<cr>", opts)
vim.keymap.set("n", "bd", "<cmd>bd<cr>", opts)

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Window resize
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<cr>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<cr>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Lazygit(Need to be installed os level)
vim.keymap.set("n", "<leader>gg", function()
	vim.cmd("tabnew")
	vim.cmd("term lazygit")
	vim.cmd("startinsert")
end, { desc = "Lazygit" })
