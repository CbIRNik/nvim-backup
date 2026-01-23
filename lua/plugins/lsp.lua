return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "rust_analyzer",
                "vtsls",
                "gopls",
            },
        },
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {}
            },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml", "BufNew Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup({
                lsp = {
                    enabled = true,
                    on_attach = function(client, bufnr)
                        local opts = { noremap = true, silent = true, buffer = bufnr }
                        vim.keymap.set("n", "K", function()
                            require("crates").show_versions_popup()
                        end, opts)
                        vim.keymap.set("n", "<leader>cv", function()
                            require("crates").show_versions_popup()
                        end, opts)
                        vim.keymap.set("n", "<leader>cf", function()
                            require("crates").show_features_popup()
                        end, opts)
                        vim.keymap.set("n", "<leader>cd", function()
                            require("crates").open_documentation()
                        end, opts)
                    end,
                    actions = true,
                    completion = true,
                    hover = true,
                },
            })
        end,
    },
}
