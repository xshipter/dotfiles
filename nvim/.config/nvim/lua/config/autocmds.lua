-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 500 })
	end,
})

-- Disable auto-comment on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Auto-reload file when changed outside of nvim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("auto_read", { clear = true }),
	command = "checktime",
})

-- Detect Django templates by presence of manage.py in project root
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("django_templates", { clear = true }),
	pattern = "*.html",
	callback = function()
		local root = vim.fn.findfile("manage.py", vim.fn.expand("%:p:h") .. ";")
		if root ~= "" then
			vim.bo.filetype = "htmldjango"
		end
	end,
})

-- Close lazygit terminal tab cleanly on exit
vim.api.nvim_create_autocmd("TermClose", {
	group = vim.api.nvim_create_augroup("lazygit_close", { clear = true }),
	pattern = "term://*lazygit*",
	callback = function()
		if vim.fn.tabpagenr("$") > 1 then
			vim.cmd("tabclose")
		else
			vim.cmd("bd!")
		end
	end,
})
