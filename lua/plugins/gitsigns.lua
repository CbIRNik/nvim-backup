return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "▶" },
            topdelete = { text = "▶" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
            follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, lhs, rhs, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            map("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gitsigns.next_hunk() end)
                return "<Ignore>"
            end, { expr = true })

            map("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gitsigns.prev_hunk() end)
                return "<Ignore>"
            end, { expr = true })

            map("n", "<leader>hs", gitsigns.stage_hunk)
            map("n", "<leader>hr", gitsigns.reset_hunk)
            map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
            map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
            map("n", "<leader>hS", gitsigns.stage_buffer)
            map("n", "<leader>hR", gitsigns.reset_buffer)
            map("n", "<leader>hp", gitsigns.preview_hunk)
            map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end)
            map("n", "<leader>hd", gitsigns.diffthis)
        end,
    },
}
