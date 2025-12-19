return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 100,
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "rust",
            "go",
            "javascript",
            "typescript",
            "tsx",
            "lua",
            "vue",
            "bash",
            "json",
            "yaml",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
            disable = {},
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
    },
}
