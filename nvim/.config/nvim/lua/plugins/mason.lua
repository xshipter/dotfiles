return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers
				"pyright",
				"ruff",
				"django-language-server",
				"typescript-language-server",
				"html-lsp",
				"json-lsp",
				"css-lsp",
				"emmet-language-server",
				"bash-language-server",
				"lua-language-server",
				"clangd",
				-- Formatters
				"stylua",
				"prettierd",
				"djlint",
				"shfmt",
				"gofumpt",
				"goimports",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
