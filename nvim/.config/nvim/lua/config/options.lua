-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- UI
vim.opt.termguicolors = true
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true
vim.opt.pumheight = 10
vim.o.pumborder = "rounded"
vim.opt.virtualedit = "block"
vim.opt.inccommand = "nosplit"

-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.autoread = true
vim.opt.autowrite = true

-- Behaviour
vim.opt.mouse = "a"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.confirm = true
vim.opt.formatoptions = "jqln"
vim.opt.completeopt = "menu,menuone,noselect"

-- Folds
vim.opt.foldlevel = 99
--vim.opt.foldlevelstart = 99

-- Diagnostics
vim.diagnostic.config({
	virtual_lines = { current_line = true },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
