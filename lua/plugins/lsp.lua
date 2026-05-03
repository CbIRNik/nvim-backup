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
        event = { "BufReadPost Cargo.toml", "BufNewFile Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local crates = require("crates")
            local has_cargo_tom = false
            local ok, cargotom = pcall(require, "config.cargotom")
            if ok then
                has_cargo_tom = cargotom.is_available()
            end

            crates.setup({
                search_indicator = true,
                completion = {
                    insert_closing_quote = true,
                    crates = {
                        enabled = not has_cargo_tom,
                        min_chars = 2,
                        max_results = 20,
                    },
                },
                popup = {
                    border = "rounded",
                },
                lsp = {
                    enabled = true,
                    on_attach = function(client, bufnr)
                        local opts = { noremap = true, silent = true, buffer = bufnr }
                        vim.keymap.set("n", "K", function()
                            crates.show_versions_popup()
                        end, vim.tbl_extend("force", opts, { desc = "Crates: show versions" }))
                        vim.keymap.set("n", "<leader>cv", function()
                            crates.show_versions_popup()
                        end, vim.tbl_extend("force", opts, { desc = "Crates: show versions" }))
                        vim.keymap.set("n", "<leader>cf", function()
                            crates.show_features_popup()
                        end, vim.tbl_extend("force", opts, { desc = "Crates: show features" }))
                        vim.keymap.set("n", "<leader>cr", crates.reload,
                            vim.tbl_extend("force", opts, { desc = "Crates: reload" }))
                        vim.keymap.set("n", "<leader>cd", function()
                            crates.open_documentation()
                        end, vim.tbl_extend("force", opts, { desc = "Crates: open docs" }))
                        vim.keymap.set("n", "<leader>cu", crates.update_crate,
                            vim.tbl_extend("force", opts, { desc = "Crates: update crate" }))
                        vim.keymap.set("v", "<leader>cu", crates.update_crates,
                            vim.tbl_extend("force", opts, { desc = "Crates: update crates" }))
                        vim.keymap.set("n", "<leader>cU", crates.upgrade_crate,
                            vim.tbl_extend("force", opts, { desc = "Crates: upgrade crate" }))
                        vim.keymap.set("v", "<leader>cU", crates.upgrade_crates,
                            vim.tbl_extend("force", opts, { desc = "Crates: upgrade crates" }))
                        vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table,
                            vim.tbl_extend("force", opts, { desc = "Crates: expand to inline table" }))
                        vim.keymap.set("n", "<leader>cH", crates.open_homepage,
                            vim.tbl_extend("force", opts, { desc = "Crates: open homepage" }))
                        vim.keymap.set("n", "<leader>cR", crates.open_repository,
                            vim.tbl_extend("force", opts, { desc = "Crates: open repository" }))
                        vim.keymap.set("n", "<leader>cC", crates.open_crates_io,
                            vim.tbl_extend("force", opts, { desc = "Crates: open crates.io" }))
                    end,
                    actions = true,
                    completion = true,
                    hover = not has_cargo_tom,
                },
            })
        end,
    },
}
