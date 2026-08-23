-- ensure_installed = {"python", "html", "htmldjango", "bash", "zsh", "css",}, -- list of parsers to install at the start of a neovim session. If set to "all", install all parsers.
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "neovim-treesitter/treesitter-parser-registry" },
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"lua",
			"python",
			"go",
			"gomod",
			"gowork",
			"zsh",
			"bash",
			"html",
			"htmldjango",
			"css",
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "python", "go", "gomod", "bash", "zsh", "lua" },
			callback = function()
				vim.treesitter.start() -- highlighting
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- folds
				vim.wo.foldmethod = "expr"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
			end,
		})
	end,
}
