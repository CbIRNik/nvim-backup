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
            "html",
            "css",
            "toml",
            "markdown",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = function(lang, buf)
                local max_filesize = 100 * 1024
                local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
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
