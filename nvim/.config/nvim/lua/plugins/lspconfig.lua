--   gra  → code_action          grn  → rename
--   grr  → references           gri  → implementation
--   grt  → type_definition      grx  → codelens action
--   gO   → document_symbols
--   <C-s> (insert) → signature_help
-- navigation bindings and extras in LspAttach below.
-- ============================================================

return {
	{
		"neovim/nvim-lspconfig",

		-- Load at startup so lsp/*.lua definitions hit the runtimepath
		-- before any buffer triggers a FileType event.
		lazy = false,

		dependencies = {
			"mason-org/mason.nvim",

			-- blink.cmp MUST be a dependency so lazy.nvim loads and configures
			-- it (including running setup()) BEFORE this config function runs.
			-- That guarantees get_lsp_capabilities() is available below.
			"saghen/blink.cmp",
		},

		config = function()
			-- ── 1. Global defaults for all servers ─────────────────
			-- vim.lsp.config('*', ...) is the wildcard — merged into every
			-- server config. blink.cmp.get_lsp_capabilities() already calls
			-- vim.lsp.protocol.make_client_capabilities() internally, so we
			-- don't need to merge manually.
			vim.lsp.config("*", {
				capabilities = {
					general = {
						positionEncodings = { "utf-8" },
					},
					require("blink.cmp").get_lsp_capabilities(),
				},
			})

			-- ── 2. Server-specific overrides ───────────────────────
			-- nvim-lspconfig already provides cmd / filetypes / root_markers
			-- for each server. We only override what we actually need to change.
			-- Anything not specified here falls back to the lspconfig defaults.

			-- Lua ─────────────────────────────────────────────────────
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							-- Make lua_ls aware of Neovim runtime + luv types
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
						},
						-- Disable lua_ls formatter — stylua handles this via conform
						format = { enable = false },
						telemetry = { enable = false },
					},
				},
			})

			-- Emmet support for html/django
			vim.lsp.config("emmet_language_server", {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascriptreact",
					"typescriptreact",
					"htmldjango",
				},

				init_options = {
					showExpandedAbbreviation = "always",
					showSuggestionsAsSnippets = true,
				},
			})

			-- TypeScript / JavaScript ─────────────────────────────────
			vim.lsp.config("ts_ls", {
				settings = {
					typescript = {
						preferences = { importModuleSpecifier = "relative" },
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = false,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypes = false,
							includeInlayFunctionLikeReturnTypeHints = false,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						preferences = { importModuleSpecifier = "relative" },
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayFunctionParameterTypeHints = false,
							includeInlayVariableTypeHints = false,
						},
					},
				},
			})

			-- Python ──────────────────────────────────────────────────
			vim.lsp.config("pyright", {
				handlers = {
					["$/progress"] = function(_, _, _)
						-- Do absolutely nothing. dropping the progressbar
					end,
				},
				-- Correct parameters: 'init_params' contains the raw client handshake, 'config' is the active engine block
				-- before_init = function(init_params, config)
				-- 	-- config.root_dir is a pre-parsed string path resolved natively by Neovim
				-- 	if config and config.root_dir then
				-- 		local manage_py = config.root_dir .. "/manage.py"
				--
				-- 		-- If manage.py is explicitly readable, switch diagnostic modes
				-- 		if vim.fn.filereadable(manage_py) == 1 then
				-- 			config.settings.python.analysis.diagnosticMode = "workspace"
				-- 		end
				-- 	end
				-- end,
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							-- Only diagnose open files (fallback default for regular files)
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			})

			-- Ruff
			vim.lsp.config("ruff", {
				on_attach = function(client, _)
					-- Disable Ruff's hover capability so it doesn't conflict with Pyright
					if client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
				end,
			})

			-- ── 3. Enable servers ──────────────────────────────────
			-- Names here are lspconfig/lsp-file names, NOT Mason package names.
			-- vim.lsp.enable() looks for lsp/<name>.lua on the runtimepath.
			-- nvim-lspconfig provides those files; hence the dependency above.
			vim.lsp.enable({
                "ruff",
				"lua_ls",
				"ts_ls",
				"pyright",
				"djls",
				"jsonls",
				"bashls",
				"cssls",
				"clangd",
				"emmet_language_server",
			})

			-- ── 4. LspAttach — buffer-local keymaps & features ────
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(ev)
					local buf = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end

					local map = function(modes, lhs, rhs, desc)
						vim.keymap.set(modes, lhs, rhs, {
							buffer = buf,
							silent = true,
							desc = "LSP: " .. desc,
						})
					end

					-- ── Navigation ─────────────────────────────────────
					-- Note: gri, grr, grn, gra, grt, grx, gO are 0.12 defaults.
					-- We add gd / gD / K which are common muscle memory.
					map("n", "gd", vim.lsp.buf.definition, "Go to definition")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "K", vim.lsp.buf.hover, "Hover documentation")

					-- ── Diagnostics ────────────────────────────────────
					map("n", "<leader>d", vim.diagnostic.open_float, "Float diagnostics")

					-- vim.diagnostic.jump() is the 0.10+ API (replaces goto_prev/next)
					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Prev diagnostic")
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Next diagnostic")
					map("n", "[e", function()
						vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
					end, "Prev error")
					map("n", "]e", function()
						vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
					end, "Next error")

					-- ── Inlay hints (toggle) ────────────────────────────
					if client:supports_method("textDocument/inlayHint") then
						-- Enable by default on attach
						vim.lsp.inlay_hint.enable(false, { bufnr = buf })

						map("n", "<leader>ih", function()
							local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
							vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
						end, "Toggle inlay hints")
					end

					-- ── LSP format (fallback if conform has no formatter for ft) ──
					map({ "n", "v" }, "<leader>lf", function()
						vim.lsp.buf.format({ async = true, bufnr = buf })
					end, "Format buffer (LSP)")
				end,
			})
		end,
	},
}
