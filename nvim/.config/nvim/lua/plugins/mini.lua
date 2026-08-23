return {
	"nvim-mini/mini.nvim",
	version = "*",
	lazy = false,
	priority = 900, -- after colorscheme
	config = function()
		-- Autopairs
		require("mini.pairs").setup()

		-- Surround
		require("mini.surround").setup()

		-- Extended text objects
		require("mini.ai").setup()

		-- Icons (used by fzf-lua, statusline, etc.)
		require("mini.icons").setup()

		-- Notifications (replaces vim.notify)
		require("mini.notify").setup()
		vim.notify = require("mini.notify").make_notify()

		-- Statusline
		require("mini.statusline").setup({
			use_icons = true,
			content = {
				active = function()
					-- 1. Helper function for a clean, combined Treesitter + LSP display
					local function get_dev_info()
						local buf = vim.api.nvim_get_current_buf()
						local parts = {}

						-- Check Tree-sitter
						local success, parser = pcall(vim.treesitter.get_parser, buf)
						if success and parser then
							table.insert(parts, " ")
						end

						-- Check LSP
						local clients = vim.lsp.get_clients({ bufnr = buf })
						if next(clients) ~= nil then
							local names = {}
							for _, client in ipairs(clients) do
								table.insert(names, client.name)
							end
							table.insert(parts, " " .. table.concat(names, ", "))
						end

						-- Only return brackets if at least one tool is running
						if #parts > 0 then
							return "[" .. table.concat(parts, " • ") .. "]"
						end
					end
					local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
					local git = MiniStatusline.section_git({ trunc_width = 75 })
					local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
					local filename = MiniStatusline.section_filename({ trunc_width = 140 })
					local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
					local location = MiniStatusline.section_location({ trunc_width = 75 })
					local lines = "%L ln"

					return MiniStatusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
						"%<", -- truncate here
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=", -- right align
						{ hl = "MiniStatuslineDevinfo", strings = { get_dev_info() } },
						{ hl = "MiniStatuslineFileinfo", strings = { fileinfo, lines } },
						{ hl = mode_hl, strings = { location } },
					})
				end,
			},
		})

		-- Git signs + hunk navigation
		require("mini.git").setup()

		-- Diff / hunk staging
		require("mini.diff").setup({
			view = {
				style = "sign",
				signs = { add = "▎", change = "▎", delete = "" },
			},
		})

		-- Keymap hints
		require("mini.clue").setup({
			window = {
				delay = 600,
			},
			triggers = {
				{ mode = "n", keys = "<leader>" },
				{ mode = "v", keys = "<leader>" },
				{ mode = "n", keys = "g" },
				{ mode = "n", keys = "z" },
				{ mode = "n", keys = "[" },
				{ mode = "n", keys = "]" },
			},
			clues = {
				require("mini.clue").gen_clues.builtin_completion(),
				require("mini.clue").gen_clues.g(),
				require("mini.clue").gen_clues.marks(),
				require("mini.clue").gen_clues.registers(),
				require("mini.clue").gen_clues.z(),

				-- Bracket Navigation Groups
				{ mode = "n", keys = "[", desc = "+prev" },
				{ mode = "n", keys = "]", desc = "+next" },

				-- Leader groups
				{ mode = { "n", "v" }, keys = "<leader>f", desc = "+find" },
				{ mode = { "n", "v" }, keys = "<leader>g", desc = "+git" },
				{ mode = { "n", "v" }, keys = "<leader>d", desc = "+diagnostics" },
				{ mode = { "n", "v" }, keys = "<leader>b", desc = "+buffer" },
			},
		})

		-- File explorer
		require("mini.files").setup({
			windows = {
				preview = true,
				width_focus = 50,
				width_nofocus = 15,
				width_preview = 50,
			},
			options = {
				permanent_delete = true,
				use_as_default_explorer = true,
			},
		})

		vim.keymap.set("n", "<leader>o", function()
			local mf = require("mini.files")
			if not mf.close() then
				mf.open(vim.fn.expand("%:p:h"))
				vim.defer_fn(function()
					mf.reveal_cwd()
				end, 30)
			end
		end, { desc = "Toggle file explorer" })

		-- Git hunk keymaps
		vim.keymap.set("n", "<leader>gh", function()
			MiniDiff.toggle_overlay()
		end, { desc = "Git hunk overlay" })
		vim.keymap.set("n", "<leader>gN", function()
			MiniDiff.goto_hunk("next")
		end, { desc = "Next hunk" })
		vim.keymap.set("n", "<leader>gP", function()
			MiniDiff.goto_hunk("prev")
		end, { desc = "Prev hunk" })
	end,
}
