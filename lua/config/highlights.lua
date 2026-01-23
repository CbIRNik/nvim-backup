local function setup_highlights()
    -- Float окна (диагностика, cmp, и т.д.)
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })

    -- CMP окна
    vim.api.nvim_set_hl(0, "CmpBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "CmpDoc", { link = "Normal" })
    vim.api.nvim_set_hl(0, "CmpPmenu", { link = "Pmenu" })

    -- Диагностика
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticSignHint", { link = "DiagnosticHint" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })

    -- Notification границы
    vim.api.nvim_set_hl(0, "NotificationBorder", { link = "FloatBorder" })

    -- Git signs colors - green for added, yellow for changed, red for deleted
    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#90ee90" })
    vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ffd700" })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff6b6b" })
end

-- Устанавливаем highlights при загрузке
setup_highlights()

-- Пересчитываем при смене темы
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("HighlightsSetup", { clear = true }),
    callback = setup_highlights,
})
