return {
    "Exafunction/codeium.vim",
    lazy = false,
    config = function()
        -- Маппинги для Codeium
        vim.keymap.set("i", "<C-g>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true, desc = "Codeium Accept" })

        vim.keymap.set("i", "<C-;>", function()
            return vim.fn["codeium#CycleCompletions"](1)
        end, { expr = true, silent = true, desc = "Codeium Next" })

        vim.keymap.set("i", "<C-,>", function()
            return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true, silent = true, desc = "Codeium Previous" })

        vim.keymap.set("i", "<C-x>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true, desc = "Codeium Clear" })

        -- Отключаем автозапуск, включаем вручную если нужно
        vim.g.codeium_enabled = true
    end,
}
