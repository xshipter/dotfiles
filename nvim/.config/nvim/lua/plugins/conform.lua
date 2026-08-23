return {
	{
		"stevearc/conform.nvim",

		-- Load only when we are about to save (keeps startup fast)
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },

		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer (conform)",
			},
		},

		opts = {
			notify_on_error = true,
			-- ── Formatter chains per filetype ────────────────────────
			-- Formatters run left-to-right; output of one feeds the next.
			-- Add more filetypes as needed.
			formatters_by_ft = {
				-- Lua
				lua = { "stylua" },

				-- JavaScript/TypeScript ecosystem
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				yaml = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				markdown = { "prettierd" },
				html = { "prettierd" },

				-- Python/Django
				htmldjango = { "djlint" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },

				-- Go
				go = { "goimports", "gofumpt" },
			},

			-- ── Format on save ────────────────────────────────────────
			-- Returning nil / false disables formatting for that save event.
			format_on_save = function(bufnr)
				-- Per-buffer opt-out  (<leader>tf in keymaps.lua)
				if vim.b[bufnr].disable_autoformat then
					return
				end
				-- Global opt-out      (<leader>tF in keymaps.lua)
				if vim.g.disable_autoformat then
					return
				end

				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,

			-- ── Per-formatter options ─────────────────────────────────
			formatters = {
				shfmt = {
					-- -i 2  : 2-space indent
					-- -ci   : indent switch cases
					-- -bn   : put binary ops at start of next line
					prepend_args = { "-i", "2", "-ci", "-bn" },
				},

				prettierd = {
					-- Respect project-local .prettierrc if present (default behaviour).
					-- Only set global fallbacks for projects without a config:
					prepend_args = function(_, ctx)
						-- Check for any local prettier config; if found, don't override
						local has_local_config = vim.fs.find({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.yaml",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
						}, { upward = true, path = ctx.dirname })[1]

						if has_local_config then
							return {}
						end

						return {
							"--single-quote",
							"--trailing-comma",
							"es5",
							"--print-width",
							"100",
						}
					end,
				},
			},
		},

		init = function()
			-- Make gq use conform's formatter when available.
			-- Falls back to the built-in Vim behaviour otherwise.
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
