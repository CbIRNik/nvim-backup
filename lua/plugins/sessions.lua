return {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        session_lens = {
            buftypes_to_ignore = {},
            previewer = false,
            theme_conf = {
                border = "rounded",
                layout_config = {
                    width = 0.8,
                    height = 0.5,
                },
            },
        },
    },
    keys = {
        { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
        { "<leader>ws", "<cmd>SessionSave<CR>",    desc = "Save session" },
        { "<leader>wl", "<cmd>SessionSearch<CR>",  desc = "Load session" },
        { "<leader>wd", "<cmd>SessionDelete<CR>",  desc = "Delete session" },
    },
}
