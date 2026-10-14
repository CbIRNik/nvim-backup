local function setup_highlights()
    local is_fate = (vim.g.colors_name or ""):match("^fate%-astolfo") ~= nil

    -- Float окна (диагностика, cmp, и т.д.)
    if not is_fate then
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    end

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
    if not is_fate then
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
    end

    -- Notification границы
    vim.api.nvim_set_hl(0, "NotificationBorder", { link = "FloatBorder" })

    -- Use the theme's GitSigns palette in both the buffer and file explorers.
    -- Do not override GitSigns with fixed RGB values on non-Fate themes.
    for name, target in pairs({
        Added = "GitSignsAdd",
        Untracked = "GitSignsAdd",
        Modified = "GitSignsChange",
        Renamed = "GitSignsChange",
        Copied = "GitSignsAdd",
        Deleted = "GitSignsDelete",
        Unmerged = "DiagnosticError",
        Ignored = "Comment",
        Staged = "GitSignsAdd",
    }) do
        vim.api.nvim_set_hl(0, "SnacksPickerGitStatus" .. name, { link = target })
    end
end

-- Устанавливаем highlights при загрузке
setup_highlights()

-- Пересчитываем при смене темы
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("HighlightsSetup", { clear = true }),
    callback = setup_highlights,
})
