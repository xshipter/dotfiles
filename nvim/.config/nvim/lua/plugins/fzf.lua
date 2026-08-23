return {
    "ibhagwan/fzf-lua",
   config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
            "telescope",
            keymap = {
                builtin = {
                    ["<C-f>"] = "preview-page-down",
                    ["<C-b>"] = "preview-page-up",
                },
                fzf = {
                    ["ctrl-q"] = "select-all+accept", -- send all to quickfix
                },
            },
        })

        vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>fa", function()
            fzf.files({ fd_opts = "--hidden --no-ignore" })
        end, { desc = "Find all files (hidden)" })
        vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
        vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fn", function()
            fzf.files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "Find in nvim config" })
        vim.keymap.set("n", "<leader>fp", function()
            fzf.files({ cwd = vim.fn.expand("~/projects/") })
        end, { desc = "Find in ~/projects/" })
        vim.keymap.set("n", "<leader>fc", function()
            fzf.files({ cwd = vim.fn.expand("%:p:h") })
        end, { desc = "Find in current file's dir" })
    end,
}
